import 'package:flutter/material.dart';
import 'package:gocv/models/education.dart';
import 'package:gocv/repositories/education.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/widgets/custom_button.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';

class AddEditEducationPage extends StatefulWidget {
  final String resumeId;
  String? educationId;

  AddEditEducationPage({
    Key? key,
    required this.resumeId,
    this.educationId,
  }) : super(key: key);

  @override
  State<AddEditEducationPage> createState() => _AddEditEducationPageState();
}

class _AddEditEducationPageState extends State<AddEditEducationPage> {
  EducationRepository educationRepository = EducationRepository();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  TextEditingController schoolNameController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController gradeScaleController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Education education = Education(
    id: 0,
    resume: 0,
    schoolName: '',
    startDate: '',
  );

  Map<String, dynamic> educationData = {
    'resume': '',
    'school_name': '',
    'degree': '',
    'department': '',
    'grade_scale': '',
    'grade': '',
    'start_date': '',
    'end_date': null,
    'description': '',
    'is_current': false,
  };

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  void dispose() {
    schoolNameController.dispose();
    degreeController.dispose();
    departmentController.dispose();
    gradeScaleController.dispose();
    gradeController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  fetchData() async {
    if (widget.educationId != null) {
      fetchEducationDetails(widget.educationId!);
    } else {
      educationData['resume'] = widget.resumeId;
      setState(() {
        isLoading = false;
        isError = false;
      });
    }
  }

  initiateControllers() {
    schoolNameController.text =
        educationData['school_name'] = education.schoolName;
    degreeController.text = educationData['degree'] = education.degree ?? '';
    departmentController.text =
        educationData['department'] = education.department ?? '';
    gradeScaleController.text =
        educationData['grade_scale'] = education.gradeScale ?? '';
    gradeController.text = educationData['grade'] = education.grade ?? '';
    startDateController.text = education.startDate;
    endDateController.text = education.endDate ?? '';
    descriptionController.text =
        educationData['description'] = education.description ?? '';
    educationData['is_current'] = education.isCurrent ?? false;

    educationData['resume'] = education.resume;
    educationData['start_date'] = education.startDate;
    educationData['end_date'] = education.endDate;

    setState(() {
      isLoading = false;
    });
  }

  fetchEducationDetails(String educationId) async {
    try {
      final response = await educationRepository.getEducationDetails(
        educationId,
      );

      if (response['status'] == Constants.httpOkCode) {
        setState(() {
          education = Education.fromJson(response['data']);
          isError = false;
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
            errorText,
            Colors.red,
          );
          Navigator.pop(context);
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error fetching education details: $error';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  createEducation() async {
    try {
      final response = await educationRepository.createEducation(educationData);

      if (response['status'] == Constants.httpCreatedCode) {
        setState(() {
          isLoading = false;
          isError = false;
        });

        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Education details added',
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
        errorText = 'Error adding education details: $error';
      });
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  updateEducation(String educationId) async {
    try {
      final response = await educationRepository.updateEducation(
        educationId,
        educationData,
      );

      if (response['status'] == Constants.httpOkCode) {
        setState(() {
          education = Education.fromJson(response['data']);
          isError = false;
        });

        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Education details updated',
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
        errorText = 'Error updating education details: $error';
      });
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  handleSubmit() async {
    setState(() {
      isLoading = true;
    });
    if (widget.educationId != null) {
      await updateEducation(widget.educationId!);
    } else {
      await createEducation();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.educationId == null
              ? 'Create New Education'
              : 'Update Education',
          style: const TextStyle(
            fontSize: 22,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 30.0,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: CustomButton(
          text:
              widget.educationId == null ? 'Add Education' : 'Update Education',
          isLoading: isLoading,
          isDisabled: isLoading,
          onPressed: () async {
            if (_formKey.currentState!.validate()) await handleSubmit();
          },
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                CustomTextFormField(
                  width: width,
                  controller: schoolNameController,
                  labelText: 'School Name',
                  hintText: 'School Name',
                  prefixIcon: Icons.business,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      educationData['school_name'] = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter school name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  width: width,
                  controller: degreeController,
                  labelText: 'Degree',
                  hintText: 'Degree',
                  prefixIcon: Icons.grade,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      educationData['degree'] = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter degree name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  width: width,
                  controller: departmentController,
                  labelText: 'Department',
                  hintText: 'Department',
                  prefixIcon: Icons.grade,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      educationData['department'] = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter department name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  width: width,
                  controller: gradeScaleController,
                  labelText: 'CGPA Scale',
                  hintText: 'CGPA Scale',
                  prefixIcon: Icons.grade,
                  textCapitalization: TextCapitalization.none,
                  borderRadius: 10,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  onChanged: (value) {
                    setState(() {
                      educationData['grade_scale'] = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cgpa scale';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  width: width,
                  controller: gradeController,
                  labelText: 'CGPA',
                  hintText: 'CGPA',
                  prefixIcon: Icons.grade,
                  textCapitalization: TextCapitalization.none,
                  borderRadius: 10,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  onChanged: (value) {
                    setState(() {
                      educationData['grade'] = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter cgpa';
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
                  width: width,
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: educationData['start_date'] != null &&
                                educationData['start_date'] != ''
                            ? DateTime.parse(educationData['start_date'])
                            : DateTime.now(),
                        firstDate: DateTime(1990, 1),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != DateTime.now()) {
                        setState(() {
                          educationData['start_date'] =
                              picked.toString().substring(0, 10);
                          startDateController.text =
                              educationData['start_date'];
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
                      value: educationData['is_current'],
                      onChanged: (value) {
                        setState(() {
                          educationData['is_current'] = value!;
                        });
                      },
                    ),
                    const Text('Currently Enrolled'),
                  ],
                ),
                educationData['is_current']
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
                              initialDate: educationData['end_date'] != null &&
                                      educationData['end_date'] != ''
                                  ? DateTime.parse(educationData['end_data']!)
                                  : DateTime.now(),
                              firstDate: DateTime(1990, 1),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null && picked != DateTime.now()) {
                              setState(() {
                                educationData['end_date'] =
                                    picked.toString().substring(0, 10);
                                endDateController.text =
                                    educationData['end_date'] ?? '';
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: endDateController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_today),
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
                      educationData['description'] = value;
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
