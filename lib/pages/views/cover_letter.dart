import 'package:cv_builder/models/person.dart';
import 'package:cv_builder/widgets/button.dart';
import 'package:cv_builder/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class CoverLetter extends StatefulWidget {
  final int type;
  final Person person;

  CoverLetter({this.type, this.person});

  @override
  _CoverLetterState createState() => _CoverLetterState();
}

class _CoverLetterState extends State<CoverLetter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            CustomTextField(
              labelText: "Cover Letter",
              hintText: "2016-2012",
              iconText: Icon(Icons.edit),
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
