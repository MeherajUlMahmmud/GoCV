import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gocv/models/contact.dart';
import 'package:gocv/providers/contact_data_provider.dart';
import 'package:gocv/repositories/contact.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class ContactPage extends StatefulWidget {
  static const String routeName = '/contact';

  final String resumeId;

  const ContactPage({
    Key? key,
    required this.resumeId,
  }) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  ContactRepository contactRepository = ContactRepository();

  late ContactDataProvider contactDataProvider;
  late String contactId;

  final _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController githubController = TextEditingController();

  Map<String, dynamic> updatedContactData = {};

  @override
  void initState() {
    super.initState();

    contactDataProvider = Provider.of<ContactDataProvider>(
      context,
      listen: false,
    );

    fetchContactDetails();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
    linkedinController.dispose();
    facebookController.dispose();
    githubController.dispose();

    super.dispose();
  }

  initiateControllers() {
    phoneNumberController.text =
        contactDataProvider.contactData.phoneNumber ?? '';
    emailController.text = contactDataProvider.contactData.email;
    addressController.text = contactDataProvider.contactData.address ?? '';
    linkedinController.text = contactDataProvider.contactData.linkedin ?? '';
    facebookController.text = contactDataProvider.contactData.facebook ?? '';
    githubController.text = contactDataProvider.contactData.github ?? '';

    setState(() {
      isLoading = false;
    });
  }

  fetchContactDetails() async {
    try {
      final response = await contactRepository.getContactDetails(
        widget.resumeId,
      );

      if (response['status'] == Constants.httpOkCode) {
        Contact contact = Contact.fromJson(response['data']);
        contactDataProvider.setContactData(contact);

        setState(() {
          contactId = contact.id.toString();
          isLoading = false;
          isError = false;
          errorText = '';
        });

        initiateControllers();
      } else {
        if (Helper().isUnauthorizedAccess(response['status'])) {
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            Constants.sessionExpiredMsg,
            Colors.red,
          );
          Helper().logoutUser(context);
        } else {
          setState(() {
            isLoading = false;
            errorText = response['message'];
          });
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            errorText,
            Colors.red,
          );
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorText = 'Error fetching contact details';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  handleUpdateContactDetails() async {
    final response = await contactRepository.updateContactDetails(
      contactId,
      updatedContactData,
    );
    print(response);

    if (response['status'] == Constants.httpOkCode) {
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        Constants.dataUpdatedMsg,
        Colors.green,
      );
    } else {
      if (Helper().isUnauthorizedAccess(response['status'])) {
        if (!mounted) return;
        Helper().showSnackBar(
          context,
          Constants.sessionExpiredMsg,
          Colors.red,
        );
        Helper().logoutUser(context);
      } else {
        setState(() {
          isLoading = false;
          isError = true;
          errorText = response['message'];
        });
        if (!mounted) return;
        Helper().showSnackBar(
          context,
          Constants.genericErrorMsg,
          Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState!.validate()) handleUpdateContactDetails();
        },
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                fetchContactDetails();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          width: width,
                          controller: phoneNumberController,
                          labelText: AppLocalizations.of(context)!.phone_number,
                          hintText: AppLocalizations.of(context)!.phone_number,
                          prefixIcon: Icons.phone,
                          textCapitalization: TextCapitalization.none,
                          borderRadius: 10,
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            setState(() {
                              updatedContactData['phone_number'] = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          width: width,
                          controller: emailController,
                          labelText: AppLocalizations.of(context)!.email,
                          hintText: AppLocalizations.of(context)!.email,
                          prefixIcon: Icons.mail,
                          textCapitalization: TextCapitalization.none,
                          borderRadius: 10,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              updatedContactData['email'] = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          width: width,
                          controller: addressController,
                          labelText: AppLocalizations.of(context)!.address,
                          hintText: AppLocalizations.of(context)!.address,
                          prefixIcon: Icons.navigation,
                          textCapitalization: TextCapitalization.sentences,
                          borderRadius: 10,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              updatedContactData['address'] = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          width: width,
                          controller: linkedinController,
                          labelText: AppLocalizations.of(context)!.linkedin,
                          hintText: AppLocalizations.of(context)!.linkedin,
                          prefixIcon: Icons.link,
                          textCapitalization: TextCapitalization.none,
                          borderRadius: 10,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              updatedContactData['linkedin'] = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          width: width,
                          controller: facebookController,
                          labelText: AppLocalizations.of(context)!.facebook,
                          hintText: AppLocalizations.of(context)!.facebook,
                          prefixIcon: Icons.facebook,
                          textCapitalization: TextCapitalization.none,
                          borderRadius: 10,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              updatedContactData['facebook'] = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          width: width,
                          controller: githubController,
                          labelText: AppLocalizations.of(context)!.github,
                          hintText: AppLocalizations.of(context)!.github,
                          prefixIcon: Icons.code,
                          textCapitalization: TextCapitalization.none,
                          borderRadius: 10,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              updatedContactData['github'] = value;
                            });
                          },
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
