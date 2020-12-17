import 'package:cv_builder/helper/db_helper.dart';
import 'package:cv_builder/models/person.dart';
import 'package:cv_builder/pages/views/education.dart';
import 'package:cv_builder/pages/views/expertise.dart';
import 'package:cv_builder/pages/views/portfolio.dart';
import 'package:cv_builder/pages/views/reference.dart';
import 'package:flutter/material.dart';

import 'views/contact.dart';
import 'views/cover_letter.dart';
import 'views/personal.dart';
import 'views/work_experience.dart';

class NewPerson extends StatefulWidget {
  final int type;
  final Person person;

  NewPerson({this.type, this.person});

  @override
  _NewPersonState createState() => _NewPersonState();
}

class _NewPersonState extends State<NewPerson>
    with SingleTickerProviderStateMixin {
  int personId = 0;
  DBHelper dbHelper = DBHelper();
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 8, vsync: this);
  }

  void initiatePerson() async {
    Person person = Person();
    personId = await dbHelper.insertPerson(person);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              TabBar(
                controller: tabController,
                indicatorColor: Colors.blueAccent,
                indicatorWeight: 3.0,
                labelColor: Theme.of(context).accentColor,
                unselectedLabelColor: Colors.grey,
                isScrollable: true,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      "Personal",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Contact",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Education",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Work Experience",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Expertise",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "References",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Cover Letter",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Portfolio",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    controller: tabController,
                    children: <Widget>[
                      Personal(type: widget.type, person: widget.person),
                      Contact(person: widget.person),
                      Educational(type: widget.type, person: widget.person),
                      Experience(type: widget.type, person: widget.person),
                      Expertise(type: widget.type, person: widget.person),
                      Reference(type: widget.type, person: widget.person),
                      CoverLetter(type: widget.type, person: widget.person),
                      Portfolio(type: widget.type, person: widget.person),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
