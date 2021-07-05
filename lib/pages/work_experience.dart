import 'package:cv_builder/models/person.dart';
import 'package:cv_builder/pages/nested_views/add_experience.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Experience extends StatefulWidget {
  final bool isEditing;
  final Person person;

  Experience({this.isEditing, this.person});

  @override
  _ExperienceState createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: Icon(
            Feather.plus,
            color: Colors.white,
          ),
          onPressed: () {
            takeToAddExperience();
          },
        ),
      ),
    );
  }

  takeToAddExperience() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExperience(),
      ),
    );
  }
}
