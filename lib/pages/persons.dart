import 'package:cv_builder/helper/db_helper.dart';
import 'package:cv_builder/models/person.dart';
import 'package:cv_builder/utils/uidata.dart';
import 'package:cv_builder/widgets/empty_view.dart';
import 'package:cv_builder/widgets/person_card.dart';
import 'package:cv_builder/widgets/profile_tile.dart';
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

  Widget header(Person person) => Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: UIData.kitGradients2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage("assets/avatars/rdj.png"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProfileTile(
                  title: person.title,
                  subtitle: "abcd",
                  // textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      );

  void _showModalBottomSheet(BuildContext context, Person person) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.grey,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: new BoxDecoration(
            color: Colors.grey,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(100.0),
              topRight: const Radius.circular(100.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              header(person),
              Divider(color: Colors.black),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewPerson(person: person),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 25,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            "Edit",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: InkWell(
                      onTap: () {
                        showDeleteDialog(context, person);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.black,
                            size: 25,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            "Delete",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(bottom: 5.0, right: 5.0),
                alignment: Alignment.bottomRight,
                child: Text(
                  "Developed by: TheTestProject",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                              splashColor: Colors.orange,
                              onTap: () => _showModalBottomSheet(
                                  context, snapshot.data[index]),
                              child: PersonCard(
                                person: snapshot.data[index],
                              ),
                            );
                            // return;
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
        onPressed: () {
          showAddDialog(context);
        },
        child: Icon(
          Feather.plus,
          color: Colors.white,
        ),
      ),
    );
  }

  void showAddDialog(BuildContext context) {
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
        await dbHelper.insertPerson(newPerson);

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

  void showDeleteDialog(BuildContext context, Person person) {
    // set up the button
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget okButton = FlatButton(
      child: Text("Delete"),
      onPressed: () async {
        await dbHelper.deletePerson(person.id);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Deleting " + person.title + "'s Profile"),
      content: Text("Are you sure about deleting this profile?"),
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
