import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gocv/repositories/personal.dart';
import 'package:gocv/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gocv/models/personal.dart';
import 'package:gocv/providers/personal_data_provider.dart';
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

  Map<String, dynamic> updatedData = {
    'first_name': '',
    'last_name': '',
    'about_me': '',
    'date_of_birth': '',
    'city': '',
    'state': '',
    'country': '',
    'nationality': '',
  };

  String imageUrl = '';
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

  void handleSessionExpired() {
    if (!mounted) return;
    Helper().showSnackBar(
      context,
      Constants.sessionExpiredMsg,
      Colors.red,
    );
    Helper().logoutUser(context);
  }

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  void setError(String error) {
    setState(() {
      isError = true;
      errorText = error;
      isLoading = false;
    });
    Helper().showSnackBar(context, error, Colors.red);
  }

  void initiateControllers() {
    final personalData = personalDataProvider.personalData;
    firstNameController.text =
        updatedData['first_name'] = personalData.firstName ?? '';
    lastNameController.text =
        updatedData['last_name'] = personalData.lastName ?? '';
    aboutMeController.text =
        updatedData['about_me'] = personalData.aboutMe ?? '';
    dobController.text =
        updatedData['date_of_birth'] = personalData.dateOfBirth ?? '';
    cityController.text = updatedData['city'] = personalData.city ?? '';
    stateController.text = updatedData['state'] = personalData.state ?? '';
    countryController.text =
        updatedData['country'] = personalData.country ?? '';
    nationalityController.text =
        updatedData['nationality'] = personalData.nationality ?? '';
    setLoading(false);
  }

  Future<File> getFromGallery() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    return File(image!.path);
  }

  Future<File> cropImage({required File imageFile}) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
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

  Future<void> fetchPersonalDetails() async {
    try {
      final response =
          await personalRepository.getPersonalDetails(widget.resumeId);
      if (response['status'] == Constants.httpOkCode) {
        final Personal personal = Personal.fromJson(response['data']);
        personalDataProvider.setPersonalData(personal);
        setState(() {
          personalId = personal.id.toString();
          imageUrl = personal.resumePicture ?? '';
          updatedImageFile = null;
          isError = false;
          errorText = '';
        });
        initiateControllers();
      } else if (Helper().isUnauthorizedAccess(response['status'])) {
        handleSessionExpired();
      } else {
        setError(response['error']);
      }
    } catch (error) {
      setError('Error fetching personal details: $error');
    }
  }

  Future<void> updatePersonalDetails() async {
    setLoading(true);
    try {
      final response = await personalRepository.updatePersonalDetails(
        personalId,
        updatedData,
      );
      if (response['status'] == Constants.httpOkCode) {
        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Personal details updated successfully',
          Colors.green,
        );
      } else if (Helper().isUnauthorizedAccess(response['status'])) {
        handleSessionExpired();
      } else {
        setError(response['error']);
        if (!mounted) return;
        Navigator.pop(context);
      }
    } catch (error) {
      setError('Error updating personal details: $error');
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateResumeImage(File updatedImageFile) async {
    setLoading(true);
    try {
      final response = await personalRepository.updatePersonalImage(
          personalId, updatedImageFile);
      if (response['status'] == Constants.httpOkCode) {
        final personal = personalDataProvider.personalData;
        personal.resumePicture = response['data']['resume_picture'];
        personalDataProvider.setPersonalData(personal);
        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Personal image updated successfully',
          Colors.green,
        );
      } else if (Helper().isUnauthorizedAccess(response['status'])) {
        handleSessionExpired();
      } else {
        setError(response['error']);
      }
    } catch (error) {
      setError('Error updating personal image: $error');
    } finally {
      setLoading(false);
    }
  }

  validatePersonalDetails() {
    if (firstNameController.text.isEmpty) {
      setError('Please enter first name');
      return false;
    }
    if (lastNameController.text.isEmpty) {
      setError('Please enter last name');
      return false;
    }
    if (dobController.text.isEmpty) {
      setError('Please enter date of birth');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState!.validate()) updatePersonalDetails();
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
                                  width: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    // border: Border.all(
                                    //   color: Theme.of(context).primaryColor,
                                    //   width: 2,
                                    // ),
                                    image: imageUrl.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                          )
                                        : DecorationImage(
                                            image: updatedImageFile != null
                                                ? AssetImage(
                                                    updatedImageFile!.path,
                                                  )
                                                : const AssetImage(
                                                    Constants.defaultAvatarPath,
                                                  ),
                                            fit: BoxFit.cover,
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
                                          updateResumeImage(value);
                                        });
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                              updatedData['first_name'] = value;
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
                          labelText: 'Last Name',
                          hintText: 'Last Name',
                          prefixIcon: Icons.person_outline,
                          textCapitalization: TextCapitalization.words,
                          borderRadius: 10,
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            setState(() {
                              updatedData['last_name'] = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter last name';
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
                              updatedData['about_me'] = value;
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
                                  updatedData['date_of_birth'] =
                                      picked.toString().substring(0, 10);
                                  dobController.text =
                                      updatedData['date_of_birth']
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter date of birth';
                                  }
                                  return null;
                                },
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
                              updatedData['city'] = value;
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
                              updatedData['state'] = value;
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
                              updatedData['country'] = value;
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
                              updatedData['nationality'] = value;
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
