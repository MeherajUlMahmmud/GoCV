import 'package:flutter/material.dart';
import 'package:gocv/models/resume.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/helper.dart';

class ResumeCard extends StatefulWidget {
  final Resume resume;
  final Function onDeleteAction;

  const ResumeCard({
    super.key,
    required this.resume,
    required this.onDeleteAction,
  });

  @override
  _ResumeCardState createState() => _ResumeCardState();
}

class _ResumeCardState extends State<ResumeCard> {
  late UserProvider userProvider;
  late String accessToken;

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
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.grey[200],
            backgroundImage: const AssetImage('assets/avatars/rdj.png'),
          ),
          const SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.resume.name,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                Helper().formatDate(widget.resume.createdAt!),
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'update',
                  child: Text('Update title'),
                ),
                const PopupMenuItem(
                  value: 'option2',
                  child: Text('Delete resume'),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'update') {
                title = widget.resume.name;
                showTitleUpdateDialog(context);
              } else {
                showDeleteDialog(context, widget.resume);
              }
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }

  showTitleUpdateDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text('Cancel'),
      onPressed: () {
        Navigator.pop(context);
      },
    );

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
          hintText: 'New title',
        ),
        keyboardType: TextInputType.text,
      ),
      actions: [
        cancelButton,
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

  void showDeleteDialog(BuildContext context, Resume resume) {
    // set up the button
    Widget cancelButton = TextButton(
      child: const Text('Cancel'),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget okButton = TextButton(
      child: const Text('Delete'),
      onPressed: () {
        widget.onDeleteAction();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Deleting ${resume.name}'),
      content: const Text('Are you sure about deleting this resume?'),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
