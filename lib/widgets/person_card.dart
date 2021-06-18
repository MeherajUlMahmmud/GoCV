import 'dart:io';

import 'package:cv_builder/helper/db_helper.dart';
import 'package:cv_builder/models/person.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class PersonCard extends StatefulWidget {
  final Person person;

  PersonCard({this.person});

  @override
  _PersonCardState createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  TextEditingController titleController = TextEditingController();

  DBHelper dbHelper = DBHelper();
  String title;

  final pdf = pw.Document();

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
                      widget.person.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    onTap: () => convertToPdf(),
                    child: Text(
                      "Convert to PDF",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.person.creationDateTime.toString(),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      title = widget.person.title;
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

  savePdf() {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                widget.person.firstName != null
                    ? widget.person.firstName
                    : "FirstName" + " " + widget.person.surname != null
                        ? widget.person.surname
                        : "LastName",
                style: pw.TextStyle(
                  fontSize: 20.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Divider(indent: 10, endIndent: 10),
            ],
          ); // Center
        },
      ),
    );

    showGiveNameDialog(context);
  }

  convertToPdf() async {
    if (await Permission.storage.request().isGranted) {
      savePdf();

      // Directory tempDir = await getTemporaryDirectory();
      // String tempPath = tempDir.path;
      // final File file =
      //     File("/storage/emulated/0/Download/${widget.person.title}.pdf");
      // await file.writeAsBytes(pdf.save());
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();

      savePdf();
    }
  }

  showGiveNameDialog(BuildContext context) {
    String name;
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Save"),
      onPressed: () async {
        final File file = File("/storage/emulated/0/Download/$name.pdf");
        await file.writeAsBytes(pdf.save());
        Navigator.pop(context);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("PDF Saved"),
        ));
      },
    );

    Widget cancelButton = FlatButton(
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
          hintText: widget.person.title,
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
    Widget okButton = FlatButton(
      child: Text("Update"),
      onPressed: () async {
        await dbHelper.updateTitle(widget.person.id, titleController.text);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Profile title"),
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
