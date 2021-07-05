import 'package:cv_builder/models/person.dart';
import 'package:cv_builder/widgets/button.dart';
import 'package:flutter/material.dart';

class CoverLetter extends StatefulWidget {
  final bool isEditing;
  final Person person;

  CoverLetter({this.isEditing, this.person});

  @override
  _CoverLetterState createState() => _CoverLetterState();
}

class _CoverLetterState extends State<CoverLetter> {
  TextEditingController coverLetterController = new TextEditingController();

  int id = 0;
  String coverLetter = "";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    @override
    void initState() {
      super.initState();

      if (widget.person != null) {
        id = widget.person.id;
        // coverLetter = widget.person.coverLetter;
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            // CustomTextField(
            //   labelText: "Cover Letter",
            //   hintText: "2016-2012",
            //   iconText: Icon(Icons.edit),
            //   ratio: 1.0,
            // ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              width: (width - 10) / 1,
              child: Theme(
                child: TextFormField(
                  maxLines: null,
                  controller: coverLetterController..text = coverLetter,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.edit),
                    labelText: "Cover Letter",
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
            Button(btnText: "Save Changes"),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
