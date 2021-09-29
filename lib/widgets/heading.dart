import 'package:flutter/material.dart';

class Heading extends StatefulWidget {
  final String title;

  Heading({this.title});

  @override
  _HeadingState createState() => _HeadingState();
}

class _HeadingState extends State<Heading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Text(
        widget.title,
        style: TextStyle(
          fontSize: 16.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
