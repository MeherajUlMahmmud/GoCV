import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gocv/screens/utility_screens/ImageViewScreen.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/widgets/custom_button.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const String routeName = '/update-profile';

  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

  final _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String uuid = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String phone = "";

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
    emailController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  readTokensAndUser() async {
    tokens = await localStorage.readData('tokens');
    user = await localStorage.readData('user');

    // get from "assets/avatars/rdj.png"
    imageFile = File("assets/avatars/rdj.png");

    firstName = user['applicant']['first_name'];
    lastName = user['applicant']['last_name'];
    email = user['email'];
    phone = user['phone'] ?? '';
    firstNameController.text = firstName;
    lastNameController.text = lastName;
    emailController.text = email;
    phoneController.text = phone;

    setState(() {
      isLoading = false;
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

  handleSubmit() {}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      resizeToAvoidBottomInset: false,
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.save),
      //   onPressed: () {
      //     if (_formKey.currentState!.validate()) handleSubmit();
      //   },
      // ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 30.0,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: CustomButton(
          text: 'Update Profile',
          isLoading: isLoading,
          isDisabled: isLoading,
          onPressed: () {
            if (_formKey.currentState!.validate()) handleSubmit();
          },
        ),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Stack(
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
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
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        width: width,
                        controller: firstNameController,
                        labelText: "First Name",
                        hintText: "First Name",
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
                        width: width,
                        controller: lastNameController,
                        labelText: "Surname",
                        hintText: "Surname",
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
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        width: width,
                        controller: emailController,
                        labelText: "Email Address",
                        hintText: "Email Address",
                        prefixIcon: Icons.email_outlined,
                        textCapitalization: TextCapitalization.none,
                        borderRadius: 10,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        width: width,
                        controller: phoneController,
                        labelText: "Phone Number",
                        hintText: "Phone Number",
                        prefixIcon: Icons.phone,
                        textCapitalization: TextCapitalization.none,
                        borderRadius: 10,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            phone = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
