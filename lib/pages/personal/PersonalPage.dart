import 'package:cv_builder/apis/personal.dart';
import 'package:cv_builder/apis/resume.dart';
import 'package:cv_builder/screens/auth_screens/LoginScreen.dart';
import 'package:cv_builder/utils/helper.dart';
import 'package:cv_builder/utils/local_storage.dart';
import 'package:flutter/material.dart';

class PersonalPage extends StatefulWidget {
  final String resumeId;
  final String personalId;
  const PersonalPage({
    Key? key,
    required this.resumeId,
    required this.personalId,
  }) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

  late Map<String, dynamic> personalDetails = {};

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  String firstName = "";
  String lastName = "";
  String aboutMe = "";
  String dateOfBirth = "";
  String nationality = "";
  String city = "";
  String state = "";
  String country = "";

  @override
  void initState() {
    super.initState();

    readTokensAndUser();
  }

  readTokensAndUser() async {
    tokens = await localStorage.readData('tokens');
    user = await localStorage.readData('user');

    fetchPersonalDetails(tokens['access'], widget.personalId);
  }

  fetchPersonalDetails(String accessToken, String personalId) {
    PersonalService()
        .getPersonalDetails(accessToken, personalId)
        .then((data) async {
      print(data);
      if (data['status'] == 200) {
        setState(() {
          personalDetails = data['data'];
          firstNameController.text = personalDetails['first_name'];
          lastNameController.text = personalDetails['last_name'];
          aboutMeController.text = personalDetails['about_me'];
          cityController.text = personalDetails['city'];
          stateController.text = personalDetails['state'];
          countryController.text = personalDetails['country'];
          isLoading = false;
          isError = false;
          errorText = '';
        });
      } else {
        if (data['status'] == 401 || data['status'] == 403) {
          Helper().showSnackBar(context, 'Session expired', Colors.red);
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else {
          setState(() {
            isLoading = false;
            isError = true;
            errorText = data['error'];
          });
          Helper().showSnackBar(
              context, 'Failed to fetch personal data', Colors.red);
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {},
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                                  controller: firstNameController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person_outline),
                                    labelText: "First Name",
                                    hintText: "First Name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      firstName = value;
                                    });
                                  },
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
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.name,
                                  controller: lastNameController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person_outline),
                                    labelText: "Surname",
                                    hintText: "Surname",
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
                                  onChanged: (value) {
                                    setState(() {
                                      lastName = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    // about me
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      width: (width - 10) / 1,
                      child: TextFormField(
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        controller: aboutMeController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_outline),
                          labelText: "About Me",
                          hintText: "About Me",
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            aboutMe = value;
                          });
                        },
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
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
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      width: (width - 10) / 1,
                      child: TextFormField(
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        controller: cityController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_city),
                          labelText: "City",
                          hintText: "City",
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            city = value;
                          });
                        },
                      ),
                    ),
                    // state
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      width: (width - 10) / 1,
                      child: TextFormField(
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        controller: cityController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.location_city),
                          labelText: "State",
                          hintText: "State",
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            state = value;
                          });
                        },
                      ),
                    ),
                    // country
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      width: (width - 10) / 1,
                      child: TextFormField(
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        controller: countryController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_outline),
                          labelText: "Country",
                          hintText: "Country",
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            country = value;
                          });
                        },
                      ),
                    ),
                    // nationality
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
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
