import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gocv/providers/user_data_provider.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';

class EmailUpdateScreen extends StatefulWidget {
  static const routeName = Constants.emailUpdateScreenRouteName;

  const EmailUpdateScreen({super.key});

  @override
  State<EmailUpdateScreen> createState() => _EmailUpdateScreenState();
}

class _EmailUpdateScreenState extends State<EmailUpdateScreen> {
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

    setState(() {
      userId = UserProvider().userData!.id.toString();

      email = UserProvider().userData!.email!;
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
        title: Text(AppLocalizations.of(context)!.update_email_address),
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
