import 'package:flutter/material.dart';

class WorkExperiencePage extends StatefulWidget {
  final String resumeId;
  const WorkExperiencePage({Key? key, required this.resumeId})
      : super(key: key);

  @override
  State<WorkExperiencePage> createState() => _WorkExperiencePageState();
}

class _WorkExperiencePageState extends State<WorkExperiencePage> {
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
