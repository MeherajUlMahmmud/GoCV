import 'package:cv_builder/helper/db_helper.dart';
import 'package:cv_builder/models/person.dart';
import 'package:cv_builder/widgets/empty_view.dart';
import 'package:cv_builder/widgets/person_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';

import 'new_person.dart';

class PersonPage extends StatefulWidget {
  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  TextEditingController titleController = TextEditingController();

  DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                initialData: [],
                future: dbHelper.getPersons(),
                builder: (context, snapshot) {
                  return snapshot.data.length > 0
                      ? ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            // print(snapshot.data[3].toString());
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NewPerson(person: snapshot.data[index]),
                                  ),
                                );
                              },
                              child: PersonCard(
                                person: snapshot.data[index],
                              ),
                            );
                          },
                        )
                      : EmptyView();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: Icon(
            Feather.plus,
            color: Colors.white,
          ),
          onPressed: () {
            showAlertDialog(context);
          },
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget okButton = FlatButton(
      child: Text("Save"),
      onPressed: () async {
        String title = titleController.text;
        titleController.clear();
        Navigator.pop(context);
        Person newPerson = Person(
          title: title,
          creationDateTime: DateFormat.yMd().add_jm().format(DateTime.now()),
        );
        int id = await dbHelper.insertPerson(newPerson);

        // Fluttertoast.showToast(
        //     msg: "Profile Created",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewPerson(type: 1, person: newPerson),
          ),
        ).then((value) {
          setState(() {});
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Profile title"),
      content: TextFormField(
        autofocus: true,
        controller: titleController,
        decoration: InputDecoration(
//              enabledBorder: UnderlineInputBorder(
//              borderSide: BorderSide(color: Colors.blue),
//            ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
//              border: UnderlineInputBorder(
//                borderSide: BorderSide(color: Colors.blue),
//              ),
          hintText: "Give a title",
        ),
        keyboardType: TextInputType.text,
      ),
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
