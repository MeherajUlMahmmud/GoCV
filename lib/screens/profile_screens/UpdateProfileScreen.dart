import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/providers/UserProfileProvider.dart';
import 'package:gocv/repositories/user.dart';
import 'package:gocv/screens/utility_screens/ImageViewScreen.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/widgets/custom_button.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const String routeName = '/update-profile';

  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  UserRepository userRepository = UserRepository();

  late UserProfileProvider userProfileProvider;
  late String userId, applicantId, firstName, lastName, phoneNumber;

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isSubmitting = false;
  bool isError = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Map<String, dynamic> updatedProfileData = {
    'first_name': '',
    'last_name': '',
    'phone_number': '',
  };

  // image
  File? imageFile;

  @override
  void initState() {
    super.initState();

    userProfileProvider = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );
    applicantId = userProfileProvider.userProfile.applicantData!.id.toString();
    firstName = userProfileProvider.userProfile.applicantData?.firstName ?? '';
    lastName = userProfileProvider.userProfile.applicantData?.lastName ?? '';
    phoneNumber =
        userProfileProvider.userProfile.applicantData?.phoneNumber ?? '';

    userId = UserProvider().userData!.id.toString();

    setState(() {
      applicantId =
          userProfileProvider.userProfile.applicantData!.id.toString();

      updatedProfileData['first_name'] = firstName;
      updatedProfileData['last_name'] = lastName;
      updatedProfileData['phone_number'] = phoneNumber;

      firstNameController.text = firstName;
      lastNameController.text = lastName;
      phoneController.text = phoneNumber;
    });

    imageFile = File('assets/avatars/rdj.png');
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();

    super.dispose();
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

  handleSubmit() async {
    setState(() {
      isSubmitting = true;
    });

    try {
      final response = await userRepository.updateUserProfile(
        userId,
        updatedProfileData,
      );
      print(response);

      if (response['status'] == Constants.httpOkCode) {
        setState(() {
          isSubmitting = false;
        });
        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Profile updated successfully',
          Colors.green,
        );
        Navigator.of(context).pop(true);
      } else {
        if (response['status'] == Constants.httpUnauthorizedCode) {
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            Constants.sessionExpiredMsg,
            Colors.red,
          );
          Helper().logoutUser(context);
        } else {
          setState(() {
            isSubmitting = false;
            isError = true;
          });
        }
      }
    } catch (error) {
      print('Error updating user profile: $error');
      if (!mounted) return;
      setState(() {
        isSubmitting = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Update Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 5.0),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
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
          isLoading: isSubmitting,
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
                    children: [
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
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.white,
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
                        labelText: 'First Name',
                        hintText: 'First Name',
                        prefixIcon: Icons.person_outline,
                        textCapitalization: TextCapitalization.words,
                        borderRadius: 10,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          setState(() {
                            updatedProfileData['first_name'] = value;
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
                        labelText: 'Surname',
                        hintText: 'Surname',
                        prefixIcon: Icons.person_outline,
                        textCapitalization: TextCapitalization.words,
                        borderRadius: 10,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          setState(() {
                            updatedProfileData['last_name'] = value;
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
                        controller: phoneController,
                        labelText: 'Phone Number',
                        hintText: 'Phone Number',
                        prefixIcon: Icons.phone,
                        textCapitalization: TextCapitalization.none,
                        borderRadius: 10,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            updatedProfileData['phone_number'] = value;
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
