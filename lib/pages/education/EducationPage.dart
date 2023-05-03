import 'package:flutter/material.dart';

class EducationPage extends StatefulWidget {
  final String resumeId;
  const EducationPage({
    Key? key,
    required this.resumeId,
  }) : super(key: key);

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
