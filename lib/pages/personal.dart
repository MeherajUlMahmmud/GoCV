import 'package:cv_builder/helper/db_helper.dart';
import 'package:cv_builder/models/person.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Personal extends StatefulWidget {
  final bool isEditing;
  final Person person;

  Personal({this.isEditing, this.person});

  @override
  _PersonalState createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController surnameController = new TextEditingController();
  TextEditingController aboutMeController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  TextEditingController nationalityController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();

  int id = 0;
  String title = "";
  String firstName = "";
  String surname = "";
  String aboutMe = "";
  String dob = "";
  String nationality = "";
  String country = "";
  String city = "";
  String creationDateTime = "";

  DBHelper dbHelper = DBHelper();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // print(widget.person.title);
    // print(widget.person.firstName);
    // print(widget.person.surname);
    // print(widget.person.email);
    // print(widget.person.aboutMe);
    // print(widget.person.firstName);
    // print(widget.person.firstName);

    if (widget.isEditing == true) {
      firstNameController.value = firstNameController.value.copyWith(
        text: widget.person.firstName,
        selection: widget.person.firstName != null
            ? TextSelection.collapsed(offset: widget.person.firstName.length)
            : null,
      );

      surnameController.value = surnameController.value.copyWith(
        text: widget.person.surname,
        selection: widget.person.surname != null
            ? TextSelection.collapsed(offset: widget.person.surname.length)
            : null,
      );

      aboutMeController.value = aboutMeController.value.copyWith(
        text: widget.person.aboutMe,
        selection: widget.person.aboutMe != null
            ? TextSelection.collapsed(offset: widget.person.aboutMe.length)
            : null,
      );

      dobController.value = dobController.value.copyWith(
        text: widget.person.dob,
        selection: widget.person.dob != null
            ? TextSelection.collapsed(offset: widget.person.dob.length)
            : null,
      );

      nationalityController.value = nationalityController.value.copyWith(
        text: widget.person.nationality,
        selection: widget.person.nationality != null
            ? TextSelection.collapsed(offset: widget.person.nationality.length)
            : null,
      );

      countryController.value = countryController.value.copyWith(
        text: widget.person.country,
        selection: widget.person.country != null
            ? TextSelection.collapsed(offset: widget.person.country.length)
            : null,
      );

      cityController.value = cityController.value.copyWith(
        text: widget.person.city,
        selection: widget.person.city != null
            ? TextSelection.collapsed(offset: widget.person.city.length)
            : null,
      );

      id = widget.person.id;
      title = widget.person.title;
      // firstName = widget.person.firstName;
      // surname = widget.person.surname;
      // aboutMe = widget.person.aboutMe;
      // dob = widget.person.dob;
      // nationality = widget.person.nationality;
      // country = widget.person.country;
      // city = widget.person.city;
      creationDateTime = widget.person.creationDateTime;
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dobController.value = TextEditingValue(
            text: DateFormat("yyyy-MM-dd").format(picked).toString());
      });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          firstName = firstNameController.text;
          surname = surnameController.text;
          aboutMe = aboutMeController.text;
          dob = dobController.text;
          nationality = nationalityController.text;
          country = countryController.text;
          city = cityController.text;
          // print(firstName);
          // print(firstNameController.text);
          // print(surname);
          // print(aboutMe);
          // print(dob);
          // print(nationality);
          // print(country);
          // print(city);
          // await dbHelper.updatePersonalInformation(
          //     id,
          //     firstNameController.text,
          //     surnameController.text,
          //     aboutMeController.text,
          //     dobController.text,
          //     nationalityController.text,
          //     countryController.text,
          //     cityController.text,
          // );
          await dbHelper.updatePersonalInformation(
            id,
            firstName,
            surname,
            aboutMe,
            dob,
            nationality,
            country,
            city,
          );
          Scaffold.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 3),
              content: Text('Personal Information Updated')));
        },
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  widget.person.title,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
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
                              textCapitalization: TextCapitalization.sentences,
                              controller: firstNameController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outline),
                                labelText: "First Name",
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
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.name,
                              controller: surnameController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_outline),
                                labelText: "Surname",
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
              SizedBox(height: 10.0),
              // about me
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                width: (width - 10) / 1,
                child: Theme(
                  child: TextFormField(
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    controller: aboutMeController,
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
              SizedBox(height: 10.0),
              // gender
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                width: (width - 10) / 1,
                child: Theme(
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: dobController,
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
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  data: Theme.of(context).copyWith(
                    primaryColor: Colors.blueAccent,
                  ),
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
                    textCapitalization: TextCapitalization.sentences,
                    controller: nationalityController,
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
                    textCapitalization: TextCapitalization.sentences,
                    controller: countryController,
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
                    textCapitalization: TextCapitalization.sentences,
                    controller: cityController,
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
            ],
          ),
        ),
      ),
    );
  }
}
