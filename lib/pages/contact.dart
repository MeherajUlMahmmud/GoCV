import 'package:cv_builder/helper/db_helper.dart';
import 'package:cv_builder/models/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Contact extends StatefulWidget {
  final bool isEditing;
  final Person person;

  Contact({this.isEditing, this.person});

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

    // print(widget.person.phone);
    // print(widget.person.email);
    // print(widget.person.address);
    // print(widget.person.linkedin);
    // print(widget.person.facebook);
    // print(widget.person.github);

    if (widget.isEditing == true) {
      // id = widget.person.id;
      // phoneNumber = widget.person.phone;
      // email = widget.person.email;
      // address = widget.person.address;
      // linkedin = widget.person.linkedin;
      // facebook = widget.person.facebook;
      // github = widget.person.github;

      phoneNumberController.value = phoneNumberController.value.copyWith(
        text: widget.person.phone,
        selection: widget.person.phone != null
            ? TextSelection.collapsed(offset: widget.person.phone.length)
            : null,
      );

      emailController.value = emailController.value.copyWith(
        text: widget.person.email,
        selection: widget.person.email != null
            ? TextSelection.collapsed(offset: widget.person.email.length)
            : null,
      );

      addressController.value = addressController.value.copyWith(
        text: widget.person.address,
        selection: widget.person.address != null
            ? TextSelection.collapsed(offset: widget.person.address.length)
            : null,
      );

      linkedinController.value = linkedinController.value.copyWith(
        text: widget.person.linkedin,
        selection: widget.person.linkedin != null
            ? TextSelection.collapsed(offset: widget.person.linkedin.length)
            : null,
      );

      facebookController.value = facebookController.value.copyWith(
        text: widget.person.facebook,
        selection: widget.person.facebook != null
            ? TextSelection.collapsed(offset: widget.person.facebook.length)
            : null,
      );

      githubController.value = githubController.value.copyWith(
        text: widget.person.github,
        selection: widget.person.github != null
            ? TextSelection.collapsed(offset: widget.person.github.length)
            : null,
      );

      id = widget.person.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          phoneNumber = phoneNumberController.text;
          email = emailController.text;
          address = addressController.text;
          linkedin = linkedinController.text;
          facebook = facebookController.text;
          github = githubController.text;

          // await dbHelper.updateContactInformation(
          //     id,
          //     phoneNumberController.text,
          //     emailController.text,
          //     addressController.text,
          //     linkedinController.text,
          //     facebookController.text,
          //     githubController.text);

          await dbHelper.updateContactInformation(id, phoneNumber, email,
              address, linkedin, facebookController.text, github);
          Scaffold.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 3),
              content: Text('Contact Information Updated')));
        },
      ),
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
                  controller: phoneNumberController,
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
                  keyboardType: TextInputType.phone,
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
                  controller: emailController,
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
                  keyboardType: TextInputType.emailAddress,
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
                  controller: addressController,
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
                  controller: linkedinController,
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
                  controller: facebookController,
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
                  controller: githubController,
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
          ],
        ),
      ),
    );
  }
}
