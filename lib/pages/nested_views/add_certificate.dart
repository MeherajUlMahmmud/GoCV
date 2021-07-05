import 'package:cv_builder/widgets/button.dart';
import 'package:cv_builder/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class AddCertificate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Add",
            ),
            Text(
              "Certificate",
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            CustomTextField(
              labelText: "Name",
              hintText: "",
              iconText: Icon(Icons.person_outline),
              ratio: 1.0,
            ),
            SizedBox(height: 10.0),
            CustomTextField(
              labelText: "Issued By",
              hintText: "",
              iconText: Icon(Icons.person_outline),
              ratio: 1.0,
            ),
            SizedBox(height: 10.0),
            CustomTextField(
              labelText: "Date",
              hintText: "",
              iconText: Icon(Icons.person_outline),
              ratio: 1.0,
            ),
            SizedBox(height: 10.0),
            Button(btnText: "Save Changes"),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
