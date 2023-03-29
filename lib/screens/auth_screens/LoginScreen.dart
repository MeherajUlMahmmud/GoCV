import 'package:cv_builder/apis/auth.dart';
import 'package:cv_builder/screens/home_screen.dart';
import 'package:cv_builder/utils/helper.dart';
import 'package:cv_builder/utils/local_storage.dart';
import 'package:cv_builder/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalStorage localStorage = LocalStorage();

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Container(
          width: 350,
          height: 450,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Login", style: TextStyle(fontSize: 30)),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Email Address",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          !isObscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text("Forgot Password?"),
                      ),
                    ],
                  ),
                  isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 10),
                            Text("Logging in..."),
                          ],
                        )
                      : CustomButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              handleLogin();
                            }
                          },
                          text: "Login",
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
