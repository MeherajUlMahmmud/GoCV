import 'package:flutter/material.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/widgets/custom_button.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class AccountSettingsScreen extends StatefulWidget {
  static const routeName = '/account-settings';

  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  late UserProvider userProvider;
  late String accessToken;
  late String userId;

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isSubmitting = false;
  bool isError = false;
  bool isOtpSent = false;
  String errorText = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  String uuid = '';
  late String email;
  String otp = '';

  @override
  void initState() {
    super.initState();

    userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    setState(() {
      accessToken = userProvider.tokens['access'].toString();
      userId = userProvider.userData!.id.toString();

      email = userProvider.userData!.email!;
      emailController.text = email;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();

    super.dispose();
  }

  handleSubmit() {}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 30.0,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: CustomButton(
          text: 'Submit',
          isLoading: isSubmitting,
          isDisabled: isLoading,
          onPressed: () {
            if (_formKey.currentState!.validate()) handleSubmit();
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        width: width,
                        controller: emailController,
                        labelText: 'Email Address',
                        hintText: 'Email address',
                        prefixIcon: Icons.email_outlined,
                        textCapitalization: TextCapitalization.words,
                        borderRadius: 10,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email address';
                          } else if (!RegExp(
                                  r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$')
                              .hasMatch(value)) {
                            return 'Please enter valid email address';
                          } else if (value == email) {
                            return 'Please enter different email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      isError
                          ? Text(
                              errorText,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            )
                          : Container(),
                      isOtpSent == true
                          ? CustomTextFormField(
                              width: width,
                              controller: otpController,
                              labelText: 'OTP',
                              hintText: 'OTP',
                              prefixIcon: Icons.pin,
                              textCapitalization: TextCapitalization.none,
                              borderRadius: 10,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  otp = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter OTP code';
                                } else if (value.length != 6) {
                                  return 'Please enter valid OTP code';
                                }
                                return null;
                              },
                            )
                          : Container(),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
