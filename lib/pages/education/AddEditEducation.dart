import 'package:flutter/material.dart';
import 'package:gocv/apis/education.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
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

  int id = 0;
  String uuid = "";
  String schoolName = "";
  String degree = "";
  String department = "";
  String gradeScale = "";
  String grade = "";
  String? startDate;
  String? endDate;
  String description = "";
  bool isCurrentlyEnrolled = false;

  @override
  void initState() {
    super.initState();

    readTokensAndUser();
  }

  readTokensAndUser() async {
    tokens = await localStorage.readData('tokens');
    user = await localStorage.readData('user');

    if (widget.educationId != null) {
      EducationService()
          .getEducation(tokens['access'], widget.educationId!)
          .then((data) {
        print(data);
        if (data['status'] == 200) {
          setState(() {
            isLoading = false;
            isError = false;
            uuid = data['data']['uuid'];
            schoolName = data['data']['school_name'];
            degree = data['data']['degree'];
            department = data['data']['department'];
            gradeScale = data['data']['grade_scale'];
            grade = data['data']['grade'];
            startDate = data['data']['start_date'];
            endDate = data['data']['end_date'];
            description = data['data']['description'];
            isCurrentlyEnrolled = data['data']['is_current'];
            schoolNameController.text = schoolName;
            degreeController.text = degree;
            departmentController.text = department;
            gradeScaleController.text = gradeScale;
            gradeController.text = grade;
            startDateController.text = startDate ?? '';
            endDateController.text = endDate ?? "";
            descriptionController.text = description;
          });
        } else {
          setState(() {
            isLoading = false;
            isError = true;
            errorText = data['error'];
          });
        }
      }).catchError((error) {
        setState(() {
          isLoading = false;
          isError = true;
          errorText = error.toString();
        });
        Helper().showSnackBar(
          context,
          error.toString(),
          Colors.red,
        );
      });
    } else {
      setState(() {
        isLoading = false;
        isError = false;
      });
    }
  }

  createEducation() {
    EducationService()
        .createEducation(
      tokens['access'],
      widget.resumeId,
      schoolName,
      degree,
      department,
      gradeScale,
      grade,
      startDate,
      endDate,
      description,
      isCurrentlyEnrolled,
    )
        .then((value) {
      if (value['status'] == 201) {
        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
          isError = true;
          errorText = value['error'];
        });
      }
    }).catchError((error) {
      setState(() {
        isLoading = false;
        isError = true;
        errorText = error.toString();
      });
      Helper().showSnackBar(
        context,
        error.toString(),
        Colors.red,
      );
    });
  }

  updateEducation() {
    EducationService()
        .updateEducation(
      tokens['access'],
      uuid,
      schoolName,
      degree,
      department,
      gradeScale,
      grade,
      startDate,
      endDate,
      description,
      isCurrentlyEnrolled,
    )
        .then((data) async {
      if (data['status'] == 200) {
        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
          isError = true;
          errorText = data['error'];
        });
      }
    });
  }

  handleSubmit() {
    setState(() {
      isLoading = true;
    });
    if (widget.educationId != null) {
      updateEducation();
    } else {
      createEducation();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: widget.educationId != null
            ? const Text("Update Education")
            : const Text("Add Education"),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState!.validate()) handleSubmit();
        },
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
                  labelText: "School Name",
                  hintText: "School Name",
                  prefixIcon: Icons.business,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      schoolName = value!;
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
                  labelText: "Degree",
                  hintText: "Degree",
                  prefixIcon: Icons.grade,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      degree = value!;
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
                  labelText: "Department",
                  hintText: "Department",
                  prefixIcon: Icons.grade,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      department = value!;
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
                  labelText: "CGPA Scale",
                  hintText: "CGPA Scale",
                  prefixIcon: Icons.grade,
                  textCapitalization: TextCapitalization.none,
                  borderRadius: 10,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  onChanged: (value) {
                    setState(() {
                      gradeScale = value!;
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
                  labelText: "CGPA",
                  hintText: "CGPA",
                  prefixIcon: Icons.grade,
                  textCapitalization: TextCapitalization.none,
                  borderRadius: 10,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  onChanged: (value) {
                    setState(() {
                      grade = value!;
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
                        initialDate: startDate != null
                            ? DateTime.parse(startDate!)
                            : DateTime.now(),
                        firstDate: DateTime(1990, 1),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != DateTime.now()) {
                        setState(() {
                          startDate = picked.toString().substring(0, 10);
                          startDateController.text = startDate ?? '';
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: startDateController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_today),
                          labelText: "Start Date",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isCurrentlyEnrolled,
                      onChanged: (value) {
                        setState(() {
                          isCurrentlyEnrolled = value!;
                        });
                      },
                    ),
                    const Text("Currently Enrolled"),
                  ],
                ),
                isCurrentlyEnrolled
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
                              initialDate: endDate != null
                                  ? DateTime.parse(endDate!)
                                  : DateTime.now(),
                              firstDate: DateTime(1990, 1),
                              lastDate: DateTime(2101),
                            );
                            if (picked != null && picked != DateTime.now()) {
                              setState(() {
                                endDate = picked.toString().substring(0, 10);
                                endDateController.text = endDate ?? "";
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: endDateController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_today),
                                labelText: "End Date",
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
                  controller: descriptionController,
                  labelText: "Description",
                  hintText: "Description",
                  prefixIcon: Icons.description,
                  textCapitalization: TextCapitalization.sentences,
                  borderRadius: 10,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      description = value!;
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
