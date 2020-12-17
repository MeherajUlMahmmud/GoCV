import 'package:cv_builder/helper/db_helper.dart';
import 'package:cv_builder/models/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Contact extends StatefulWidget {
  final Person person;

  Contact({this.person});

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController linkedinController = new TextEditingController();
  TextEditingController facebookController = new TextEditingController();
  TextEditingController githubController = new TextEditingController();

  int id = 0;
  String phoneNumber = "";
  String email = "";
  String address = "";
  String linkedin = "";
  String facebook = "";
  String github = "";

  DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();

    if (widget.person != null) {
      id = widget.person.id;
      phoneNumber = widget.person.phone;
      email = widget.person.email;
      address = widget.person.address;
      linkedin = widget.person.linkedin;
      facebook = widget.person.facebook;
      github = widget.person.github;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              width: (width - 10) / 1,
              child: Theme(
                child: TextFormField(
                  maxLines: null,
                  controller: phoneNumberController..text = phoneNumber,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Feather.phone),
                    labelText: "Phone Number",
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              width: (width - 10) / 1,
              child: Theme(
                child: TextFormField(
                  maxLines: null,
                  controller: emailController..text = email,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Feather.mail),
                    labelText: "Email Address",
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              width: (width - 10) / 1,
              child: Theme(
                child: TextFormField(
                  maxLines: null,
                  controller: addressController..text = address,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Feather.navigation),
                    labelText: "Address",
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              width: (width - 10) / 1,
              child: Theme(
                child: TextFormField(
                  maxLines: null,
                  controller: linkedinController..text = linkedin,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Feather.linkedin),
                    labelText: "LinkedIn",
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              width: (width - 10) / 1,
              child: Theme(
                child: TextFormField(
                  maxLines: null,
                  controller: facebookController..text = facebook,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Feather.facebook),
                    labelText: "Facebook",
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              width: (width - 10) / 1,
              child: Theme(
                child: TextFormField(
                  maxLines: null,
                  controller: githubController..text = github,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Feather.github),
                    labelText: "Github",
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () async {
                await dbHelper.updateContactInformation(
                    id,
                    phoneNumberController.text,
                    emailController.text,
                    addressController.text,
                    linkedinController.text,
                    facebookController.text,
                    githubController.text);
              },
              child: Container(
                height: 60.0,
                width: width - 10,
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Theme.of(context).accentColor,
                  child: Center(
                    child: Text(
                      "Save Changes",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
