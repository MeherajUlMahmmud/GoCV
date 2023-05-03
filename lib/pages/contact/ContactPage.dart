import 'package:cv_builder/apis/contact.dart';
import 'package:cv_builder/screens/auth_screens/LoginScreen.dart';
import 'package:cv_builder/utils/helper.dart';
import 'package:cv_builder/utils/local_storage.dart';
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

    print(widget.contactId);
    readTokensAndUser();
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: TextFormField(
                maxLines: null,
                controller: phoneNumberController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: "Phone Number",
                  hintText: "Phone Number",
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: TextFormField(
                maxLines: null,
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: "Email",
                  hintText: "Email Address",
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: TextFormField(
                maxLines: null,
                controller: addressController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.navigation),
                  labelText: "Address",
                  hintText: "Address",
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: TextFormField(
                maxLines: null,
                controller: linkedinController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.link),
                  labelText: "LinkedIn",
                  hintText: "LinkedIn",
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: TextFormField(
                maxLines: null,
                controller: facebookController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.facebook),
                  labelText: "Facebook",
                  hintText: "Facebook",
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: TextFormField(
                maxLines: null,
                controller: githubController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.code),
                  labelText: "Github",
                  hintText: "Github",
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
