import 'package:flutter/material.dart';

class ResumeCard extends StatefulWidget {
  final Map<String, dynamic> resume;

  ResumeCard({required this.resume});

  @override
  _ResumeCardState createState() => _ResumeCardState();
}

class _ResumeCardState extends State<ResumeCard> {
  TextEditingController titleController = TextEditingController();

  late String title;

  // final pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 5.0,
      margin: EdgeInsets.all(10.0),
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: AssetImage("assets/avatars/rdj.png"),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      widget.resume['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                // Container(
                //   padding: EdgeInsets.all(8.0),
                //   decoration: BoxDecoration(
                //     color: Colors.blueAccent,
                //     borderRadius: BorderRadius.circular(15.0),
                //   ),
                //   child: InkWell(
                //     onTap: () => convertToPdf(),
                //     child: Text(
                //       "Convert to PDF",
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Last Updated: " + widget.resume['updated_at'].toString(),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      title = widget.resume['name'];
                    });
                    showTitleUpdateDialog(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16.0),
                      SizedBox(width: 10.0),
                      Text("Edit Title"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  convertToPdf() async {
    // if (await Permission.storage.request().isGranted) {
    //   savePdf();

    // Directory tempDir = await getTemporaryDirectory();
    // String tempPath = tempDir.path;
    // final File file =
    //     File("/storage/emulated/0/Download/${widget.resume.title}.pdf");
    // await file.writeAsBytes(pdf.save());
    // } else {
    //   Map<Permission, PermissionStatus> statuses = await [
    //     Permission.storage,
    //   ].request();

    //   savePdf();
    // }
  }

  savePdf() {
    // pdf.addPage(
    //   pw.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (pw.Context context) {
    //       return pw.Column(
    //         children: [
    //           pw.Text(
    //             widget.resume.firstName != null
    //                 ? widget.resume.firstName
    //                 : "FirstName" + " " + widget.resume.surname != null
    //                     ? widget.resume.surname
    //                     : "LastName",
    //             style: pw.TextStyle(
    //               fontSize: 20.0,
    //               fontWeight: pw.FontWeight.bold,
    //             ),
    //           ),
    //           pw.Divider(indent: 10, endIndent: 10),
    //         ],
    //       ); // Center
    //     },
    //   ),
    // );

    showGiveNameDialog(context);
  }

  showGiveNameDialog(BuildContext context) {
    String name;
    // set up the button
    Widget okButton = ElevatedButton(
      child: Text("Save"),
      onPressed: () async {
        // final File file = File("/storage/emulated/0/Download/$name.pdf");
        // await file.writeAsBytes(pdf.save());
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("PDF Saved"),
        ));
      },
    );

    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Resume title"),
      content: TextFormField(
        autofocus: true,
        onChanged: (value) {
          setState(() {
            name = value;
          });
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          hintText: widget.resume['name'],
        ),
      ),
      actions: [okButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showTitleUpdateDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Update"),
      onPressed: () async {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Update Resume title"),
      content: TextFormField(
        autofocus: true,
        controller: titleController..text = title,
        decoration: InputDecoration(
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

    // show the dialog
    showDialog(
      context: context,
      // builder: (BuildContext context) {
      //   return alert;
      // },
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
