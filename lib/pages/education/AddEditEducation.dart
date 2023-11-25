import 'package:flutter/material.dart';
import 'package:gocv/apis/api.dart';
import 'package:gocv/models/education.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/utils/urls.dart';
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
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

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

  Education education = Education();

  Map<String, dynamic> educationData = {
    'resume': '',
    'school_name': '',
    'degree': '',
    'department': '',
    'grade_scale': '',
    'grade': '',
    'start_date': '',
    'end_date': '',
    'description': '',
    'is_current': false,
  };

  @override
  void initState() {
    super.initState();

    readTokensAndUser();
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

  readTokensAndUser() async {
    tokens = await localStorage.readData('tokens');
    user = await localStorage.readData('user');

    if (widget.educationId != null) {
      fetchEducation(tokens['access'], widget.educationId!);
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
        educationData['school_name'] = education.schoolName ?? '';
    degreeController.text = educationData['degree'] = education.degree ?? '';
    departmentController.text =
        educationData['department'] = education.department ?? '';
    gradeScaleController.text =
        educationData['grade_scale'] = education.gradeScale ?? '';
    gradeController.text = educationData['grade'] = education.grade ?? '';
    startDateController.text = education.startDate ?? '';
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

  fetchEducation(String accessToken, String educationId) {
    if (educationId == '') {
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Education ID is empty';
      });
      Helper().showSnackBar(
        context,
        'Education ID is empty',
        Colors.red,
      );
      return;
    }
    String url = '${URLS.kEducationUrl}$educationId/details/';
    APIService().sendGetRequest(accessToken, url).then((data) {
      print(data);
      if (data['status'] == 200) {
        setState(() {
          education = Education.fromJson(data['data']);
          isError = false;
        });

        initiateControllers();
      } else {
        setState(() {
          isLoading = false;
          isError = true;
          errorText = data['data']['detail'];
        });
        Helper().showSnackBar(
          context,
          errorText,
          Colors.red,
        );
      }
    }).catchError((error) {
      setState(() {
        isLoading = false;
        isError = true;
        errorText = error.toString();
      });
      Helper().showSnackBar(
        context,
        'Error fetching education details',
        Colors.red,
      );
    });
  }

  createEducation() {
    // EducationService()
    //     .createEducation(
    //   tokens['access'],
    //   widget.resumeId,
    //   schoolName,
    //   degree,
    //   department,
    //   gradeScale,
    //   grade,
    //   startDate,
    //   endDate,
    //   description,
    //   isCurrentlyEnrolled,
    // )
    //     .then((value) {
    //   if (value['status'] == 201) {
    //     Navigator.pop(context);
    //   } else {
    //     setState(() {
    //       isLoading = false;
    //       isError = true;
    //       errorText = value['error'];
    //     });
    //   }
    // }).catchError((error) {
    //   setState(() {
    //     isLoading = false;
    //     isError = true;
    //     errorText = error.toString();
    //   });
    //   Helper().showSnackBar(
    //     context,
    //     error.toString(),
    //     Colors.red,
    //   );
    // });
  }

  updateEducation(String accessToken, String educationId) {
    String url = '${URLS.kEducationUrl}$educationId/update/';
    APIService()
        .sendPatchRequest(
      accessToken,
      educationData,
      url,
    )
        .then((data) async {
      print(data);
      if (data['status'] == 200) {
        setState(() {
          education = Education.fromJson(data['data']);
          isError = false;
        });

        initiateControllers();
      } else {
        setState(() {
          isLoading = false;
          isError = true;
          errorText = data['data']['detail'];
        });
        Helper().showSnackBar(
          context,
          errorText,
          Colors.red,
        );
      }
    }).catchError((error) {
      setState(() {
        isLoading = false;
        isError = true;
        errorText = error.toString();
      });
      Helper().showSnackBar(
        context,
        'Error updating education',
        Colors.red,
      );
    });
  }

  handleSubmit() {
    setState(() {
      isLoading = true;
    });
    if (widget.educationId != null) {
      updateEducation(tokens['access'], widget.educationId!);
    } else {
      createEducation();
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
          widget.educationId == null
              ? 'Create New Education'
              : 'Update Education',
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
        actions: [
          widget.educationId != null
              ? GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Education'),
                          content: const Text(
                            'Are you sure you want to delete this education?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // deleteExperience(
                                //   tokens['access'],
                                //   widget.experienceId!,
                                // );
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
                    padding: const EdgeInsets.all(12.0),
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
          text:
              widget.educationId == null ? 'Add Education' : 'Update Education',
          isLoading: isLoading,
          isDisabled: isLoading,
          onPressed: () {
            if (_formKey.currentState!.validate()) handleSubmit();
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
