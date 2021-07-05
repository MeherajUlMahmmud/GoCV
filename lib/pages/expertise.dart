import 'package:cv_builder/models/person.dart';
import 'package:cv_builder/widgets/custom_text_view.dart';
import 'package:flutter/material.dart';

class Expertise extends StatefulWidget {
  final bool isEditing;
  final Person person;

  Expertise({this.isEditing, this.person});

  @override
  _ExpertiseState createState() => _ExpertiseState();
}

class _ExpertiseState extends State<Expertise> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 5.0),
          Card(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: CustomTextView(title: "Add Languages"),
                ),
              ],
            ),
          ),
          SizedBox(height: 5.0),
          Card(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: CustomTextView(title: "Add Personal Skills"),
                ),
              ],
            ),
          ),
          SizedBox(height: 5.0),
          Card(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: CustomTextView(title: "Add Certificate Information"),
                ),
              ],
            ),
          ),
          SizedBox(height: 5.0),
          Card(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: CustomTextView(title: "Add Interests"),
                ),
              ],
            ),
          ),
          SizedBox(height: 5.0),
        ],
      ),
    );
  }
}
