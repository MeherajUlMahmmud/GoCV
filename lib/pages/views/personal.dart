import 'package:cv_builder/helper/db_helper.dart';
import 'package:cv_builder/models/person.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Personal extends StatefulWidget {
  final int type;
  final Person person;

  Personal({this.type, this.person});

  @override
  _PersonalState createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController surnameController = new TextEditingController();
  TextEditingController jobTitleController = new TextEditingController();
  TextEditingController aboutMeController = new TextEditingController();
  TextEditingController genderController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  TextEditingController nationalityController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();

  int id = 0;
  String title = "";
  String firstName = "";
  String surname = "";
  String jobTitle = "";
  String aboutMe = "";
  String gender = "Male";
  String nationality = "";
  String country = "Bangladesh";
  String city = "";
  String creationDateTime = "";

  String selectedGender;
  List<String> genderList = <String>[
    "Male",
    "Female",
  ];

  DBHelper dbHelper = DBHelper();

  DateTime selectedDate = DateTime.now();

  // String formattedDate = DateFormat.yMMMd().format(DateTime.now());
  String formattedDate;

  String dob = DateFormat.yMMMd().format(DateTime.now());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1899, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat.yMMMd().format(selectedDate);
      });
  }

  @override
  void initState() {
    super.initState();

    if (widget.person != null) {
      id = widget.person.id;
      title = widget.person.title;
      firstName = widget.person.firstName;
      surname = widget.person.surname;
      jobTitle = widget.person.jobTitle;
      aboutMe = widget.person.aboutMe;
      gender = widget.person.gender;
      dob = widget.person.dob;
      nationality = widget.person.nationality;
      country = widget.person.country;
      city = widget.person.city;
      creationDateTime = widget.person.creationDateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.arrow_back,
                            size: 30.0,
                          ),
                        ),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff211551),
                        ),
                      ),
                      // Expanded(
                      //   child: TextField(
                      //     controller: TextEditingController()..text = title,
                      //     onSubmitted: (value) async {
                      //       if (value.isNotEmpty) {
                      //         if (widget.person == null) {
                      //           Person newPerson = Person(
                      //             title: value,
                      //             creationDateTime: DateFormat.yMd()
                      //                 .add_jm()
                      //                 .format(DateTime.now()),
                      //           );
                      //           id = await dbHelper.insertPerson(newPerson);
                      //           print("inserted");
                      //         } else {
                      //           await dbHelper.updateTitle(
                      //               widget.person.id, value);
                      //           print("Updated");
                      //         }
                      //       }
                      //     },
                      //     decoration: InputDecoration(
                      //       hintText: "Profile Title",
                      //       border: InputBorder.none,
                      //     ),
                      //     style: TextStyle(
                      //       fontSize: 22.0,
                      //       fontWeight: FontWeight.bold,
                      //       color: Color(0xff211551),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                // image and name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(8.0),
                      height: 110,
                      width: 123,
                      child: Image.asset("assets/avatars/rdj.png"),
                    ),
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            width: (width - 10) / 1.8,
                            child: Theme(
                              child: TextFormField(
                                maxLines: null,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: firstNameController
                                  ..text = firstName,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_outline),
                                  labelText: "First Name",
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent),
                                  ),
                                ),
                              ),
                              data: Theme.of(context).copyWith(
                                primaryColor: Colors.blueAccent,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            width: (width - 10) / 1.8,
                            child: Theme(
                              child: TextFormField(
                                maxLines: null,
                                keyboardType: TextInputType.name,
                                controller: surnameController..text = surname,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_outline),
                                  labelText: "Surname",
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent),
                                  ),
                                ),
                              ),
                              data: Theme.of(context).copyWith(
                                primaryColor: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  width: (width - 10) / 1,
                  child: Theme(
                    child: TextFormField(
                      maxLines: null,
                      controller: jobTitleController..text = jobTitle,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline),
                        labelText: "Job Title",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                // about me
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  width: (width - 10) / 1,
                  child: Theme(
                    child: TextFormField(
                      maxLines: null,
                      controller: aboutMeController..text = aboutMe,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline),
                        labelText: "About Me",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                    ),
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.blueAccent,
                    ),
                  ),
                ),
                // gender
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: DropDownField(
                    controller: genderController
                      ..text = gender == null ? genderList[0] : gender,
                    enabled: true,
                    onValueChanged: (value) {
                      setState(() {
                        selectedGender = value;
                        genderController..text = selectedGender;
                      });
                    },
                    value: selectedGender,
                    required: false,
                    labelText: 'Gender',
                    items: genderList,
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        width: (width - 10) / 1.2,
                        child: Theme(
                          child: AbsorbPointer(
                            child: TextFormField(
                              // onSaved: (val) {
                              //   creationDateTime = formattedDate;
                              // },
                              // enabled: false,
                              // readOnly: true,
                              controller: dobController
                                ..text =
                                    formattedDate == null ? dob : formattedDate,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.calendar_today),
                                labelText: "Date of Birth",
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          data: Theme.of(context).copyWith(
                            primaryColor: Colors.blueAccent,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                // nationality
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  width: (width - 10) / 1,
                  child: Theme(
                    child: TextFormField(
                      maxLines: null,
                      controller: nationalityController..text = nationality,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline),
                        labelText: "Nationality",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                // country
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  width: (width - 10) / 1,
                  child: Theme(
                    child: TextFormField(
                      maxLines: null,
                      controller: countryController..text = country,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_outline),
                        labelText: "Country",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                // city
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  width: (width - 10) / 1,
                  child: Theme(
                    child: TextFormField(
                      maxLines: null,
                      controller: cityController..text = city,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_city),
                        labelText: "City",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () async {
                    await dbHelper.updatePersonalInformation(
                        id,
                        firstNameController.text,
                        surnameController.text,
                        jobTitleController.text,
                        aboutMeController.text,
                        genderController.text,
                        dobController.text,
                        nationalityController.text,
                        countryController.text,
                        cityController.text);
                  },
                  child: Container(
                    height: 60.0,
                    width: width - 10,
                    child: Material(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Theme.of(context).accentColor,
                      child: Center(
                        child: Text(
                          "Save Changes",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
