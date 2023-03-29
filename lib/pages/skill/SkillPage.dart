import 'package:flutter/material.dart';

class SkillPage extends StatefulWidget {
  final String resumeId;
  const SkillPage({Key? key, required this.resumeId}) : super(key: key);

  @override
  State<SkillPage> createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage> {
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
