import 'package:cv_builder/models/person.dart';
import 'package:cv_builder/pages/nested_views/add_education.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Educational extends StatefulWidget {
  final bool isEditing;
  final Person person;

  Educational({this.isEditing, this.person});

  @override
  _EducationalState createState() => _EducationalState();
}

class _EducationalState extends State<Educational> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[],
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: Icon(
            Feather.plus,
            color: Colors.white,
          ),
          onPressed: () {
            takeToAddEducation();
          },
        ),
      ),
    );
  }

  takeToAddEducation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEducation(),
      ),
    );
  }
}
