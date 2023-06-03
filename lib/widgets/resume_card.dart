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
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 5.0,
      margin: const EdgeInsets.all(10.0),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30.0,
                      backgroundImage: AssetImage("assets/avatars/rdj.png"),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      widget.resume['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // const SizedBox(height: 10.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Last Updated: ${widget.resume['updated_at']}",
            //       style: const TextStyle(
            //         fontSize: 14.0,
            //         color: Colors.black54,
            //       ),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           title = widget.resume['name'];
            //         });
            //         showTitleUpdateDialog(context);
            //       },
            //       child: Row(
            //         children: const [
            //           Icon(Icons.edit, size: 16.0),
            //           SizedBox(width: 10.0),
            //           Text("Edit Title"),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  showTitleUpdateDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: const Text("Update"),
      onPressed: () async {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Update Resume title"),
      content: TextFormField(
        autofocus: true,
        controller: titleController..text = title,
        decoration: const InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          hintText: "New title",
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
