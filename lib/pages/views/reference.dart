import 'package:cv_builder/models/person.dart';
import 'package:cv_builder/pages/views/nested_views/add_reference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Reference extends StatefulWidget {
  final int type;
  final Person person;

  Reference({this.type, this.person});

  @override
  _ReferenceState createState() => _ReferenceState();
}

class _ReferenceState extends State<Reference> {
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
            takeToAddReference();
          },
        ),
      ),
    );
  }

  takeToAddReference() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReference(),
      ),
    );
  }
}
