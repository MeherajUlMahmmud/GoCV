import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final String resumeId;
  const ContactPage({Key? key, required this.resumeId}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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
                // controller: phoneNumberController,
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
                // controller: emailController,
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
                // controller: addressController,
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
                // controller: linkedinController,
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
                // controller: facebookController,
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
                // controller: githubController,
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
