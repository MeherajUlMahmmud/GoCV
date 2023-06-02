import 'package:gocv/apis/personal.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';
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

  final _formKey = GlobalKey<FormState>();

  late Map<String, dynamic> personalDetails = {};

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();

  String uuid = "";
  String firstName = "";
  String lastName = "";
  String aboutMe = "";
  String dateOfBirth = "";
  String city = "";
  String state = "";
  String country = "";
  String nationality = "";

  @override
  void initState() {
    super.initState();

    readTokensAndUser();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    aboutMeController.dispose();
    dobController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    nationalityController.dispose();

    super.dispose();
  }

  readTokensAndUser() async {
    tokens = await localStorage.readData('tokens');
    user = await localStorage.readData('user');

    fetchPersonalDetails(tokens['access'], widget.personalId);
  }

  fetchPersonalDetails(String accessToken, String personalId) {
    PersonalService()
        .getPersonalDetails(
      accessToken,
      personalId,
    )
        .then((data) async {
      print(data);
      if (data['status'] == 200) {
        setState(() {
          personalDetails = data['data'];
          uuid = personalDetails['uuid'];
          firstName = personalDetails['first_name'];
          lastName = personalDetails['last_name'];
          aboutMe = personalDetails['about_me'] ?? '';
          city = personalDetails['city'] ?? '';
          state = personalDetails['state'] ?? '';
          country = personalDetails['country'] ?? '';
          nationality = personalDetails['nationality'] ?? '';
          firstNameController.text = firstName;
          lastNameController.text = lastName;
          aboutMeController.text = aboutMe;
          cityController.text = city;
          stateController.text = state;
          countryController.text = country;
          nationalityController.text = nationality;

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

  handleUpdatePersonalDetails() {
    PersonalService()
        .updatePersonalDetails(
      tokens['access'],
      uuid,
      firstName,
      lastName,
      aboutMe,
      city,
      state,
      country,
      nationality,
    )
        .then((data) async {
      if (data['status'] == 200) {
        Helper().showSnackBar(
          context,
          'Personal details updated successfully',
          Colors.green,
        );
      } else {
        Helper().showSnackBar(
          context,
          'Failed to update personal details',
          Colors.red,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            handleUpdatePersonalDetails();
          }
        },
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // image and name
                    Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 120,
                          width: 120,
                          child: Image.asset("assets/avatars/rdj.png"),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                width: (width - 10) / 1.6,
                                controller: firstNameController,
                                labelText: "First Name",
                                hintText: "First Name",
                                prefixIcon: Icons.person_outline,
                                textCapitalization: TextCapitalization.words,
                                borderRadius: 20,
                                keyboardType: TextInputType.name,
                                onChanged: (value) {
                                  setState(() {
                                    firstName = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter first name';
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                width: (width - 10) / 1.6,
                                controller: lastNameController,
                                labelText: "Surname",
                                hintText: "Surname",
                                prefixIcon: Icons.person_outline,
                                textCapitalization: TextCapitalization.words,
                                borderRadius: 20,
                                keyboardType: TextInputType.name,
                                onChanged: (value) {
                                  setState(() {
                                    lastName = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter surname';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    CustomTextFormField(
                      width: width,
                      controller: aboutMeController,
                      labelText: "About Me",
                      hintText: "About Me",
                      prefixIcon: Icons.person_outline,
                      textCapitalization: TextCapitalization.sentences,
                      borderRadius: 20,
                      keyboardType: TextInputType.multiline,
                      onChanged: (value) {
                        setState(() {
                          aboutMe = value;
                        });
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 8.0,
                      ),
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
                              prefixIcon: const Icon(Icons.calendar_today),
                              labelText: "Date of Birth",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                    ),
                    CustomTextFormField(
                      width: width,
                      controller: cityController,
                      labelText: "City",
                      hintText: "City",
                      prefixIcon: Icons.location_city,
                      textCapitalization: TextCapitalization.sentences,
                      borderRadius: 20,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          city = value;
                        });
                      },
                    ),
                    CustomTextFormField(
                      width: width,
                      controller: stateController,
                      labelText: "State",
                      hintText: "State",
                      prefixIcon: Icons.person_outline,
                      textCapitalization: TextCapitalization.sentences,
                      borderRadius: 20,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          state = value;
                        });
                      },
                    ),
                    CustomTextFormField(
                      width: width,
                      controller: countryController,
                      labelText: "Country",
                      hintText: "Country",
                      prefixIcon: Icons.person_outline,
                      textCapitalization: TextCapitalization.words,
                      borderRadius: 20,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          country = value;
                        });
                      },
                    ),
                    CustomTextFormField(
                      width: width,
                      controller: nationalityController,
                      labelText: "Nationality",
                      hintText: "Nationality",
                      prefixIcon: Icons.person_outline,
                      textCapitalization: TextCapitalization.sentences,
                      borderRadius: 20,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        setState(() {
                          nationality = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
