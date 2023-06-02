import 'package:gocv/apis/contact.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final String resumeId;
  final String contactId;
  const ContactPage({
    Key? key,
    required this.resumeId,
    required this.contactId,
  }) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

  final _formKey = GlobalKey<FormState>();

  late Map<String, dynamic> contactDetails = {};

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController githubController = TextEditingController();

  int id = 0;
  String phoneNumber = "";
  String email = "";
  String address = "";
  String linkedin = "";
  String facebook = "";
  String github = "";

  @override
  void initState() {
    super.initState();

    readTokensAndUser();
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

  readTokensAndUser() async {
    tokens = await localStorage.readData('tokens');
    user = await localStorage.readData('user');

    fetchContactDetails(tokens['access'], widget.contactId);
  }

  fetchContactDetails(String accessToken, String contactId) {
    ContactService()
        .getContactDetails(accessToken, contactId)
        .then((data) async {
      print(data);
      if (data['status'] == 200) {
        setState(() {
          contactDetails = data['data'];
          phoneNumberController.text = contactDetails['phone_number'] ?? '';
          emailController.text = contactDetails['email'] ?? '';
          addressController.text = contactDetails['address'] ?? '';
          linkedinController.text = contactDetails['linkedin'] ?? '';
          facebookController.text = contactDetails['facebook'] ?? '';
          githubController.text = contactDetails['github'] ?? '';
          isLoading = false;
          isError = false;
          errorText = '';
        });
      } else {
        if (data['status'] == 401 || data['status'] == 403) {
          Helper().showSnackBar(context, 'Session expired', Colors.red);
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else {
          setState(() {
            isLoading = false;
            isError = true;
            errorText = data['error'];
          });
          Helper().showSnackBar(
              context, 'Failed to fetch personal data', Colors.red);
          Navigator.pop(context);
        }
      }
    });
  }

  handleUpdateContactDetails() {
    ContactService()
        .updateContactDetails(
      tokens['access'],
      widget.contactId,
      phoneNumberController.text,
      emailController.text,
      addressController.text,
      linkedinController.text,
      facebookController.text,
      githubController.text,
    )
        .then((data) async {
      print(data);
      if (data['status'] == 200) {
        Helper().showSnackBar(context, 'Contact details updated', Colors.green);
      } else {
        if (data['status'] == 401 || data['status'] == 403) {
          Helper().showSnackBar(context, 'Session expired', Colors.red);
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else {
          Helper().showSnackBar(
              context, 'Failed to update contact details', Colors.red);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            handleUpdateContactDetails();
          }
        },
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CustomTextFormField(
                width: width,
                controller: phoneNumberController,
                labelText: "Phone Number",
                hintText: "Phone Number",
                prefixIcon: Icons.phone,
                textCapitalization: TextCapitalization.none,
                borderRadius: 20,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
              ),
              CustomTextFormField(
                width: width,
                controller: emailController,
                labelText: "Email",
                hintText: "Email Address",
                prefixIcon: Icons.mail,
                textCapitalization: TextCapitalization.none,
                borderRadius: 20,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email address';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                width: width,
                controller: addressController,
                labelText: "Address",
                hintText: "Address",
                prefixIcon: Icons.navigation,
                textCapitalization: TextCapitalization.sentences,
                borderRadius: 20,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    address = value;
                  });
                },
              ),
              CustomTextFormField(
                width: width,
                controller: linkedinController,
                labelText: "LinkedIn",
                hintText: "LinkedIn",
                prefixIcon: Icons.link,
                textCapitalization: TextCapitalization.none,
                borderRadius: 20,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    linkedin = value;
                  });
                },
              ),
              CustomTextFormField(
                width: width,
                controller: facebookController,
                labelText: "Facebook",
                hintText: "Facebook",
                prefixIcon: Icons.facebook,
                textCapitalization: TextCapitalization.none,
                borderRadius: 20,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    facebook = value;
                  });
                },
              ),
              CustomTextFormField(
                width: width,
                controller: githubController,
                labelText: "Github",
                hintText: "Github",
                prefixIcon: Icons.code,
                textCapitalization: TextCapitalization.none,
                borderRadius: 20,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    github = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
