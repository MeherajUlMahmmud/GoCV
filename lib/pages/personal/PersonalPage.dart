import 'dart:async';
import 'dart:io';

import 'package:gocv/apis/api.dart';
import 'package:gocv/apis/personal.dart';
import 'package:gocv/utils/urls.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/screens/utility_screens/ImageViewScreen.dart';
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

  String id = '';
  String firstName = '';
  String lastName = '';
  String aboutMe = '';
  String dateOfBirth = '';
  String city = '';
  String state = '';
  String country = '';
  String nationality = '';

  // image
  File? imageFile;

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

    // get from "assets/avatars/rdj.png"
    imageFile = File('assets/avatars/rdj.png');

    fetchPersonalDetails(tokens['access'], widget.personalId);
  }

  fetchPersonalDetails(String accessToken, String personalId) {
    String URL = '${URLS.kPersonalUrl}$personalId/details/';
    APIService().sendGetRequest(accessToken, URL).then((data) async {
      if (data['status'] == 200) {
        setState(() {
          personalDetails = data['data'];
          id = personalDetails['id'].toString();
          firstName = personalDetails['first_name'];
          lastName = personalDetails['last_name'];
          aboutMe = personalDetails['about_me'] ?? '';
          dateOfBirth = personalDetails['date_of_birth'] ?? '';
          city = personalDetails['city'] ?? '';
          state = personalDetails['state'] ?? '';
          country = personalDetails['country'] ?? '';
          nationality = personalDetails['nationality'] ?? '';
          firstNameController.text = firstName;
          lastNameController.text = lastName;
          aboutMeController.text = aboutMe;
          dobController.text = dateOfBirth;
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

  Future<File> getFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    File file = File(image!.path);
    return file;
  }

  Future<File> cropImage({required File imageFile}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
    );
    return File(croppedFile!.path);
  }

  handleUpdatePersonalDetails() {
    PersonalService()
        .updatePersonalDetails(
      tokens['access'],
      id,
      firstName,
      lastName,
      aboutMe,
      dateOfBirth,
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
          if (_formKey.currentState!.validate()) handleUpdatePersonalDetails();
        },
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                height: 140,
                                width: width * 0.28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.blueGrey,
                                    width: 1,
                                  ),
                                ),
                                child: ImageFullScreenWrapperWidget(
                                  dark: true,
                                  // child: Image.asset("assets/avatars/rdj.png"),
                                  child: Image.asset(imageFile!.path),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    getFromGallery().then((value) {
                                      cropImage(imageFile: value).then((value) {
                                        setState(() {
                                          imageFile = value;
                                        });
                                      });
                                    });
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  width: width * 0.6,
                                  controller: firstNameController,
                                  labelText: 'First Name',
                                  hintText: 'First Name',
                                  prefixIcon: Icons.person_outline,
                                  textCapitalization: TextCapitalization.words,
                                  borderRadius: 10,
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
                                const SizedBox(height: 5),
                                CustomTextFormField(
                                  width: width * 0.6,
                                  controller: lastNameController,
                                  labelText: 'Surname',
                                  hintText: 'Surname',
                                  prefixIcon: Icons.person_outline,
                                  textCapitalization: TextCapitalization.words,
                                  borderRadius: 10,
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
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        width: width,
                        controller: aboutMeController,
                        labelText: 'About Me',
                        hintText: 'About Me',
                        prefixIcon: Icons.person_outline,
                        textCapitalization: TextCapitalization.sentences,
                        borderRadius: 10,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          setState(() {
                            aboutMe = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 5.0,
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
                                dateOfBirth =
                                    picked.toString().substring(0, 10);
                                dobController.text = dateOfBirth;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: dobController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_today),
                                labelText: 'Date of Birth',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 10),
                      // CustomTextFormField(
                      //   width: width,
                      //   controller: cityController,
                      //   labelText: "City",
                      //   hintText: "City",
                      //   prefixIcon: Icons.location_city,
                      //   textCapitalization: TextCapitalization.sentences,
                      //   borderRadius: 10,
                      //   keyboardType: TextInputType.text,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       city = value;
                      //     });
                      //   },
                      // ),
                      // const SizedBox(height: 10),
                      // CustomTextFormField(
                      //   width: width,
                      //   controller: stateController,
                      //   labelText: "State",
                      //   hintText: "State",
                      //   prefixIcon: Icons.person_outline,
                      //   textCapitalization: TextCapitalization.sentences,
                      //   borderRadius: 10,
                      //   keyboardType: TextInputType.text,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       state = value;
                      //     });
                      //   },
                      // ),
                      // const SizedBox(height: 10),
                      // CustomTextFormField(
                      //   width: width,
                      //   controller: countryController,
                      //   labelText: "Country",
                      //   hintText: "Country",
                      //   prefixIcon: Icons.person_outline,
                      //   textCapitalization: TextCapitalization.words,
                      //   borderRadius: 10,
                      //   keyboardType: TextInputType.text,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       country = value;
                      //     });
                      //   },
                      // ),
                      // const SizedBox(height: 10),
                      // CustomTextFormField(
                      //   width: width,
                      //   controller: nationalityController,
                      //   labelText: "Nationality",
                      //   hintText: "Nationality",
                      //   prefixIcon: Icons.person_outline,
                      //   textCapitalization: TextCapitalization.sentences,
                      //   borderRadius: 10,
                      //   keyboardType: TextInputType.text,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       nationality = value;
                      //     });
                      //   },
                      // ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
