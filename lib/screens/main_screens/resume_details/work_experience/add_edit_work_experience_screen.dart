import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../models/experience.dart';
import '../../../../repositories/experience.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/helper.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_form_field.dart';

class AddEditWorkExperiencePage extends StatefulWidget {
  final String resumeId;
  String? experienceId;

  AddEditWorkExperiencePage({
    Key? key,
    required this.resumeId,
    this.experienceId,
  }) : super(key: key);

  @override
  State<AddEditWorkExperiencePage> createState() =>
      _AddEditWorkExperiencePageState();
}

class _AddEditWorkExperiencePageState extends State<AddEditWorkExperiencePage> {
  ExperienceRepository experienceRepository = ExperienceRepository();

  List<String> types = [
    'Full Time',
    'Part Time',
    'Internship',
    'Contract',
    'Freelance',
    'Volunteer',
    'Apprenticeship',
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  TextEditingController companyNameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController companyWebsiteController = TextEditingController();

  Experience experience = Experience(
    id: 0,
    resume: 0,
    companyName: '',
    position: '',
    type: '',
    startDate: '',
  );

  Map<String, dynamic> experienceData = {
    'resume': '',
    'company_name': '',
    'position': '',
    'type': '',
    'start_date': '',
    'end_date': null,
    'description': '',
    'company_website': '',
    'is_current': false,
  };

  String typeError = '';

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  void dispose() {
    companyNameController.dispose();
    positionController.dispose();
    typeController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    descriptionController.dispose();
    companyWebsiteController.dispose();

    super.dispose();
  }

  fetchData() {
    if (widget.experienceId != null) {
      fetchWorkExperienceDetails(widget.experienceId!);
    } else {
      experienceData['resume'] = widget.resumeId;
      setState(() {
        isLoading = false;
        isError = false;
      });
    }
  }

  initiateControllers() {
    companyNameController.text = experience.companyName;
    positionController.text = experience.position;
    typeController.text = experience.type;
    startDateController.text = experience.startDate;
    endDateController.text = experience.endDate ?? '';
    descriptionController.text = experience.description ?? '';
    companyWebsiteController.text = experience.companyWebsite ?? '';

    experienceData['resume'] = experience.resume;
    experienceData['company_name'] = experience.companyName;
    experienceData['position'] = experience.position;
    experienceData['type'] = experience.type;
    experienceData['start_date'] = experience.startDate;
    experienceData['is_current'] = experience.isCurrent ?? false;
    experienceData['end_date'] = experience.endDate;
    experienceData['description'] = experience.description ?? '';
    experienceData['company_website'] = experience.companyWebsite ?? '';

    setState(() {
      isLoading = false;
    });
  }

  fetchWorkExperienceDetails(String experienceId) async {
    try {
      final response = await experienceRepository.getExperienceDetails(
        experienceId,
      );

      if (response['status'] == Constants.httpOkCode) {
        final Experience fetchedExperience =
            Experience.fromJson(response['data']);
        setState(() {
          experience = fetchedExperience;
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
            errorText = response['message'];
          });
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            errorText,
            Colors.red,
          );
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error fetching experience: $error';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  createExperience() async {
    try {
      final response = await experienceRepository.createExperience(
        widget.resumeId,
        experienceData,
      );

      if (response['status'] == Constants.httpCreatedCode) {
        setState(() {
          isLoading = false;
          isError = true;
        });
        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Experience created successfully',
          Colors.green,
        );
        Navigator.pop(context);
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
            errorText = response['error'];
          });
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            errorText,
            Colors.red,
          );
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorText = 'Error creating experience: $error';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  updateExperience(String experienceId) async {
    try {
      final response = await experienceRepository.updateExperience(
        experienceId,
        experienceData,
      );

      if (response['status'] == Constants.httpOkCode) {
        setState(() {
          isLoading = false;
          isError = false;
          errorText = '';
        });
        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Experience updated successfully',
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
            errorText = response['message'];
          });
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            errorText,
            Colors.red,
          );
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorText = 'Error updating experience: $error';
      });
      print(error);
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  deleteExperience(String experienceId) async {
    try {
      final response = await experienceRepository.deleteExperience(
        experienceId,
      );

      if (response['status'] == Constants.httpNoContentCode) {
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.pop(context);
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
            errorText = response['message'];
          });
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            errorText,
            Colors.red,
          );
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorText = 'Error deleting experience: $error';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  handleSubmit() {
    setState(() {
      isLoading = true;
    });
    if (widget.experienceId != null) {
      updateExperience(widget.experienceId!);
    } else {
      createExperience();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.experienceId == null
              ? 'Create New Experience'
              : 'Update Experience',
          style: const TextStyle(
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
            child: Container(
              margin: const EdgeInsets.only(left: 5.0),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
        ),
        actions: [
          widget.experienceId != null
              ? GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Experience'),
                          content: const Text(
                            'Are you sure you want to delete this experience?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await deleteExperience(widget.experienceId!);
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.only(right: 10.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      resizeToAvoidBottomInset: false,
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
          text: widget.experienceId == null
              ? 'Add Work Experience'
              : 'Update Work Experience',
          isLoading: isLoading,
          isDisabled: isLoading,
          onPressed: () {
            if (typeController.text.isEmpty) {
              setState(() {
                typeError = 'Please enter job type';
              });
            } else {
              setState(() {
                typeError = '';
              });
            }
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
                    children: [
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        width: width,
                        controller: companyNameController,
                        labelText: 'Company Name',
                        hintText: 'Company Name',
                        prefixIcon: Icons.business,
                        textCapitalization: TextCapitalization.words,
                        borderRadius: 10,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          setState(() {
                            experienceData['company_name'] = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter company name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        width: width,
                        controller: positionController,
                        labelText: 'Position',
                        hintText: 'Position',
                        prefixIcon: Icons.work_outline_rounded,
                        textCapitalization: TextCapitalization.sentences,
                        borderRadius: 10,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            experienceData['position'] = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter position';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 5.0,
                        ),
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              errorText: typeError == '' ? null : typeError,
                              labelText: 'Job Type',
                              hintText: 'Job Type',
                              prefixIcon:
                                  const Icon(Icons.work_outline_rounded),
                            ),
                            controller: typeController,
                          ),
                          suggestionsCallback: (pattern) {
                            List<String> matches = <String>[];
                            matches.addAll(types);
                            matches.retainWhere((s) {
                              return s
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase());
                            });
                            return matches;
                          },
                          itemBuilder: (context, item) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Divider(),
                                ],
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            setState(() {
                              typeController.text = suggestion.toString();
                              experienceData['type'] = suggestion.toString();
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 5.0,
                        ),
                        width: width,
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: experienceData['start_date'] !=
                                          null &&
                                      experienceData['start_date'] != ''
                                  ? DateTime.parse(experienceData['start_date'])
                                  : DateTime.now(),
                              firstDate: DateTime(1990, 1),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null && picked != DateTime.now()) {
                              setState(() {
                                experienceData['start_date'] =
                                    picked.toString().substring(0, 10);
                                startDateController.text =
                                    experienceData['start_date'];
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: startDateController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_today),
                                labelText: 'Start Date',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter start date';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: experienceData['is_current'],
                            onChanged: (value) {
                              setState(() {
                                experienceData['is_current'] = value!;
                              });
                            },
                          ),
                          const Text('Currently Working'),
                        ],
                      ),
                      experienceData['is_current']
                          ? Container()
                          : Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                                vertical: 5.0,
                              ),
                              width: width,
                              child: GestureDetector(
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        experienceData['end_date'] != null &&
                                                experienceData['end_date'] != ''
                                            ? DateTime.parse(
                                                experienceData['end_data']!)
                                            : DateTime.now(),
                                    firstDate: DateTime(1990, 1),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null &&
                                      picked != DateTime.now()) {
                                    setState(() {
                                      experienceData['end_date'] =
                                          picked.toString().substring(0, 10);
                                      endDateController.text =
                                          experienceData['end_date'] ?? '';
                                    });
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: endDateController,
                                    decoration: InputDecoration(
                                      prefixIcon:
                                          const Icon(Icons.calendar_today),
                                      labelText: 'End Date',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter end date';
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
                        controller: descriptionController,
                        labelText: 'Description',
                        hintText: 'Description',
                        prefixIcon: Icons.description,
                        textCapitalization: TextCapitalization.sentences,
                        borderRadius: 10,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            experienceData['description'] = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        width: width,
                        controller: companyWebsiteController,
                        labelText: 'Company Website',
                        hintText: 'Company Website',
                        prefixIcon: Icons.link,
                        textCapitalization: TextCapitalization.sentences,
                        borderRadius: 10,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          setState(() {
                            experienceData['company_website'] = value;
                          });
                        },
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
