import 'package:flutter/material.dart';

class PersonalPage extends StatefulWidget {
  final String resumeId;
  const PersonalPage({Key? key, required this.resumeId}) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  TextEditingController dobController = TextEditingController();

  String firstName = "";
  String lastName = "";
  String aboutMe = "";
  String dateOfBirth = "";
  String nationality = "";
  String city = "";
  String state = "";
  String country = "";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {},
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // image and name
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(8.0),
                    height: 120,
                    width: 120,
                    child: Image.asset("assets/avatars/rdj.png"),
                  ),
                  Container(
                    margin: EdgeInsets.all(5.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 8.0,
                          ),
                          width: (width - 10) / 1.6,
                          child: TextFormField(
                            maxLines: null,
                            textCapitalization: TextCapitalization.words,
                            // controller: firstNameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person_outline),
                              labelText: "First Name",
                              hintText: "First Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 8.0,
                          ),
                          width: (width - 10) / 1.6,
                          child: TextFormField(
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.name,
                            // controller: surnameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person_outline),
                              labelText: "Surname",
                              hintText: "Surname",
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
                        ),
                      ],
                    ),
                  )
                ],
              ),
              // about me
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                width: (width - 10) / 1,
                child: TextFormField(
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  // controller: aboutMeController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: "About Me",
                    hintText: "About Me",
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                width: (width - 10) / 1,
                child: GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1985, 1),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != DateTime.now()) {
                      setState(() {
                        dateOfBirth = picked.toString().substring(0, 10);
                        dobController.text = dateOfBirth;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: dobController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        labelText: "Date of Birth",
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ),
              // city
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                width: (width - 10) / 1,
                child: TextFormField(
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  // controller: cityController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_city),
                    labelText: "City",
                    hintText: "City",
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              // state
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                width: (width - 10) / 1,
                child: TextFormField(
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  // controller: cityController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_city),
                    labelText: "State",
                    hintText: "State",
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              // country
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                width: (width - 10) / 1,
                child: TextFormField(
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  // controller: countryController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: "Country",
                    hintText: "Country",
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              // nationality
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                width: (width - 10) / 1,
                child: TextFormField(
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  // controller: nationalityController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: "Nationality",
                    hintText: "Nationality",
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
