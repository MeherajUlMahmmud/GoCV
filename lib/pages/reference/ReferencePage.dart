import 'package:flutter/material.dart';

class ReferencePage extends StatefulWidget {
  final String resumeId;
  const ReferencePage({Key? key, required this.resumeId}) : super(key: key);

  @override
  State<ReferencePage> createState() => _ReferencePageState();
}

class _ReferencePageState extends State<ReferencePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {},
      ),
    );
  }
}
