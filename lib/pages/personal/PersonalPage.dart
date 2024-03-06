import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gocv/repositories/personal.dart';
import 'package:gocv/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gocv/models/personal.dart';
import 'package:gocv/providers/PersonalDataProvider.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';

class PersonalPage extends StatefulWidget {
  static const String routeName = '/personal';

  final String resumeId;

  const PersonalPage({
    Key? key,
    required this.resumeId,
  }) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  PersonalRepository personalRepository = PersonalRepository();

  late PersonalDataProvider personalDataProvider;
  late String personalId;

  final _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  late TextEditingController firstNameController = TextEditingController();
  late TextEditingController lastNameController = TextEditingController();
  late TextEditingController aboutMeController = TextEditingController();
  late TextEditingController dobController = TextEditingController();
  late TextEditingController cityController = TextEditingController();
  late TextEditingController stateController = TextEditingController();
  late TextEditingController countryController = TextEditingController();
  late TextEditingController nationalityController = TextEditingController();

  Map<String, dynamic> updatedPersonalData = {};

  // image
  File? updatedImageFile;

  @override
  void initState() {
    super.initState();

    personalDataProvider = Provider.of<PersonalDataProvider>(
      context,
      listen: false,
    );

    fetchPersonalDetails();
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

  initiateControllers() {
    firstNameController.text =
        personalDataProvider.personalData.firstName ?? '';
    lastNameController.text = personalDataProvider.personalData.lastName ?? '';
    aboutMeController.text = personalDataProvider.personalData.aboutMe ?? '';
    dobController.text = personalDataProvider.personalData.dateOfBirth ?? '';
    cityController.text = personalDataProvider.personalData.city ?? '';
    stateController.text = personalDataProvider.personalData.state ?? '';
    countryController.text = personalDataProvider.personalData.country ?? '';
    nationalityController.text =
        personalDataProvider.personalData.nationality ?? '';

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

  fetchPersonalDetails() async {
    try {
      final response = await personalRepository.getPersonalDetails(
        widget.resumeId,
      );

      if (response['status'] == Constants.httpOkCode) {
        Personal personal = Personal.fromJson(response['data']);
        personalDataProvider.setPersonalData(personal);

        setState(() {
          personalId = personal.id.toString();
          updatedImageFile = null;
          isError = false;
          errorText = '';
        });

        initiateControllers();
      } else {
        if (Helper().isUnauthorizedAccess(response['status'])) {
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            Constants.sessionExpiredMsg,
            Colors.red,
          );
          Helper().logoutUser(context);
        } else {
          setState(() {
            isLoading = false;
            isError = true;
            errorText = response['error'];
          });
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            'Failed to fetch personal data',
            Colors.red,
          );
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error fetching personal details: $error';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        'Error fetching personal details',
        Colors.red,
      );
    }
  }

  handleUpdatePersonalDetails() async {
    try {
      final response = await personalRepository.updatePersonalDetails(
        personalId,
        updatedPersonalData,
      );
      if (response['status'] == Constants.httpOkCode) {
        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Personal details updated successfully',
          Colors.green,
        );
      } else {
        if (Helper().isUnauthorizedAccess(response['status'])) {
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            Constants.sessionExpiredMsg,
            Colors.red,
          );
          Helper().logoutUser(context);
        } else {
          setState(() {
            isLoading = false;
            isError = true;
            errorText = response['error'];
          });
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            'Failed to update personal data',
            Colors.red,
          );
          Navigator.pop(context);
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error updating personal details: $error';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        'Error updating personal details',
        Colors.red,
      );
    }
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
          : RefreshIndicator(
              onRefresh: () async {
                fetchPersonalDetails();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          height: 180,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Stack(
                              children: [
                                Container(
                                  height: 180,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                    ),
                                    image: DecorationImage(
                                      image: updatedImageFile != null
                                          ? AssetImage(updatedImageFile!.path)
                                          : const AssetImage(
                                              Constants.defultAvatarPath),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      getFromGallery().then((value) {
                                        cropImage(imageFile: value)
                                            .then((value) {
                                          setState(() {
                                            updatedImageFile = value;
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
                          ),
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
                              updatedPersonalData['first_name'] = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
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
                              updatedPersonalData['last_name'] = value;
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
                          controller: aboutMeController,
                          labelText: 'About Me',
                          hintText: 'About Me',
                          prefixIcon: Icons.person_outline,
                          textCapitalization: TextCapitalization.sentences,
                          borderRadius: 10,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) {
                            setState(() {
                              updatedPersonalData['about_me'] = value;
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
                                  updatedPersonalData['date_of_birth'] =
                                      picked.toString().substring(0, 10);
                                  dobController.text =
                                      updatedPersonalData['date_of_birth']
                                          .toString()
                                          .substring(0, 10);
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
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          width: width,
                          controller: cityController,
                          labelText: 'City',
                          hintText: 'City',
                          prefixIcon: Icons.location_city,
                          textCapitalization: TextCapitalization.sentences,
                          borderRadius: 10,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              updatedPersonalData['city'] = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          width: width,
                          controller: stateController,
                          labelText: 'State',
                          hintText: 'State',
                          prefixIcon: Icons.person_outline,
                          textCapitalization: TextCapitalization.sentences,
                          borderRadius: 10,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              updatedPersonalData['state'] = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          width: width,
                          controller: countryController,
                          labelText: 'Country',
                          hintText: 'Country',
                          prefixIcon: Icons.person_outline,
                          textCapitalization: TextCapitalization.words,
                          borderRadius: 10,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              updatedPersonalData['country'] = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          width: width,
                          controller: nationalityController,
                          labelText: 'Nationality',
                          hintText: 'Nationality',
                          prefixIcon: Icons.person_outline,
                          textCapitalization: TextCapitalization.sentences,
                          borderRadius: 10,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              updatedPersonalData['nationality'] = value;
                            });
                          },
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
