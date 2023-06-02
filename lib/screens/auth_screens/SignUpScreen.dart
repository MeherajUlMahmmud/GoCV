import 'package:flutter/material.dart';
import 'package:gocv/apis/auth.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/widgets/custom_button.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "/signup";
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String firstName = "";
  String lastName = "";
  String email = "";
  String password = "";
  String confirmPassword = "";

  bool isObscure = true;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  handleSignUp() {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });

    AuthService()
        .registerUser(
      firstName,
      lastName,
      email,
      password,
    )
        .then((data) async {
      print(data);
      if (data['status'] == 200) {
        setState(() {
          isLoading = false;
        });

        Helper().showSnackBar(
          context,
          'Registration Successful',
          Colors.green,
        );

        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      } else {
        setState(() {
          isLoading = false;
        });
        Helper().showSnackBar(
          context,
          'Something went wrong',
          Colors.red,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
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
                  "Welcome",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Create an account to continue!",
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
                  controller: firstNameController,
                  labelText: 'First Name',
                  hintText: 'First Name',
                  prefixIcon: Icons.person,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      firstName = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  width: width,
                  controller: lastNameController,
                  labelText: 'Last Name',
                  hintText: 'Last Name',
                  prefixIcon: Icons.person,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      lastName = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  width: width,
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
                CustomTextFormField(
                  width: width,
                  controller: confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Confirm Password',
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
                      confirmPassword = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your confirm password';
                    } else if (value != password) {
                      return 'Password does not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                CustomButton(
                  text: "Sign Up",
                  isLoading: isLoading,
                  isDisabled: isLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      handleSignUp();
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          LoginScreen.routeName,
                        );
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
