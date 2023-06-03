import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gocv/apis/auth.dart';
import 'package:gocv/screens/auth_screens/SignUpScreen.dart';
import 'package:gocv/screens/home_screen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/widgets/custom_button.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalStorage localStorage = LocalStorage();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String email = "";
  String password = "";

  bool isObscure = true;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  handleLogin() {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });

    AuthService().loginUser(email, password).then((data) async {
      print(data);
      if (data['status'] == 200) {
        await localStorage.writeData('user', data['data']['user']);
        await localStorage.writeData('tokens', data['data']['tokens']);

        Helper().showSnackBar(context, 'Login Successful', Colors.green);
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else {
        setState(() {
          isLoading = false;
        });
        Helper().showSnackBar(context, data['error'], Colors.red);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -160,
            left: -30,
            child: topWidget(screenSize.width),
          ),
          Positioned(
            bottom: -180,
            left: -40,
            child: bottomWidget(screenSize.width),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "GoCV",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Welcome back",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Login to continue",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      width: width,
                      autofocus: true,
                      controller: emailController,
                      labelText: 'Email',
                      hintText: 'Email Address',
                      prefixIcon: Icons.email,
                      textCapitalization: TextCapitalization.none,
                      borderRadius: 10,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 5),
                    CustomTextFormField(
                      width: width,
                      controller: passwordController,
                      labelText: 'Password',
                      hintText: 'Password',
                      prefixIcon: Icons.lock,
                      suffixIcon:
                          !isObscure ? Icons.visibility : Icons.visibility_off,
                      textCapitalization: TextCapitalization.none,
                      borderRadius: 10,
                      keyboardType: TextInputType.visiblePassword,
                      isObscure: isObscure,
                      suffixIconOnPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("Forgot Password?"),
                      ),
                    ),
                    CustomButton(
                      text: "Login",
                      isLoading: isLoading,
                      isDisabled: isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          handleLogin();
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              SignUpScreen.routeName,
                            );
                          },
                          child: const Text("Sign Up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget topWidget(double screenWidth) {
    return Transform.rotate(
      angle: -35 * math.pi / 180,
      child: Container(
        width: 1.2 * screenWidth,
        height: 1.2 * screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          gradient: const LinearGradient(
            begin: Alignment(-0.2, -0.8),
            end: Alignment.bottomCenter,
            colors: [
              Color(0x007CBFCF),
              Color(0xB316BFC4),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomWidget(double screenWidth) {
    return Container(
      width: 1.5 * screenWidth,
      height: 1.5 * screenWidth,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment(0.6, -1.1),
          end: Alignment(0.7, 0.8),
          colors: [
            Color(0xDB4BE8CC),
            Color(0x005CDBCF),
          ],
        ),
      ),
    );
  }
}
