import 'package:flutter/material.dart';

class ResumeCard extends StatefulWidget {
  final Map<String, dynamic> resume;

  const ResumeCard({super.key, required this.resume});

  @override
  _ResumeCardState createState() => _ResumeCardState();
}

class _ResumeCardState extends State<ResumeCard> {
  TextEditingController titleController = TextEditingController();

  late String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const CircleAvatar(
            radius: 50.0,
            backgroundImage: AssetImage('assets/avatars/rdj.png'),
          ),
          const SizedBox(height: 10.0),
          Text(
            widget.resume['name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  showTitleUpdateDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text('Update'),
      onPressed: () async {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Update Resume title'),
      content: TextFormField(
        autofocus: true,
        controller: titleController..text = title,
        decoration: const InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          hintText: 'New title',
        ),
        keyboardType: TextInputType.text,
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return alert;
          },
        );
      },
    );
  }
}
