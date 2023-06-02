import 'package:gocv/apis/experience.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddWorkExperiencePage extends StatefulWidget {
  final String resumeId;
  String? experienceId;

  AddWorkExperiencePage({
    Key? key,
    required this.resumeId,
    this.experienceId,
  }) : super(key: key);

  @override
  State<AddWorkExperiencePage> createState() => _AddWorkExperiencePageState();
}

class _AddWorkExperiencePageState extends State<AddWorkExperiencePage> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};
  List<String> types = [
    "Full Time",
    "Part Time",
    "Internship",
    "Contract",
    "Freelance",
    "Volunteer",
    "Apprenticeship",
    "Traineeship",
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Map<String, dynamic> contactDetails = {};

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  TextEditingController companyNameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController salaryController = TextEditingController();

  int id = 0;
  String uuid = "";
  String companyName = "";
  String position = "";
  String type = "";
  String startDate = "";
  String? endDate;
  String description = "";
  String salary = "";
  bool isCurrentlyWorking = false;

  String typeError = "";

  @override
  void initState() {
    super.initState();

    readTokensAndUser();
  }

  readTokensAndUser() async {
    tokens = await localStorage.readData('tokens');
    user = await localStorage.readData('user');

    if (widget.experienceId != null) {
      ExpreienceService()
          .getExperience(tokens['access'], widget.experienceId!)
          .then((data) {
        print(data);
        if (data['status'] == 200) {
          setState(() {
            isLoading = false;
            isError = false;
            uuid = data['data']['uuid'];
            companyName = data['data']['company_name'];
            position = data['data']['position'];
            type = data['data']['type'];
            startDate = data['data']['start_date'];
            endDate = data['data']['end_date'];
            description = data['data']['description'];
            salary = data['data']['salary'].toString();
            isCurrentlyWorking = data['data']['is_current'];
            companyNameController.text = companyName;
            positionController.text = position;
            typeController.text = type;
            startDateController.text = startDate;
            endDateController.text = endDate ?? "";
            descriptionController.text = description;
            salaryController.text = salary;
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

  createExperience() {
    ExpreienceService()
        .createExperience(
            tokens['access'],
            widget.resumeId,
            companyName,
            position,
            type,
            startDate,
            endDate,
            description,
            salary,
            isCurrentlyWorking)
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

  updateExperience() {
    ExpreienceService()
        .updateExperience(
      tokens['access'],
      uuid,
      companyName,
      position,
      type,
      startDate,
      endDate,
      description,
      salary,
      isCurrentlyWorking,
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
    if (widget.experienceId != null) {
      updateExperience();
    } else {
      createExperience();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Work Experience'),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          if (typeController.text.isEmpty) {
            setState(() {
              typeError = "Please enter job type";
            });
          } else {
            setState(() {
              typeError = "";
            });
          }
          if (_formKey.currentState!.validate()) handleSubmit();
        },
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              CustomTextFormField(
                width: width,
                controller: companyNameController,
                labelText: "Company Name",
                hintText: "Company Name",
                prefixIcon: Icons.business,
                textCapitalization: TextCapitalization.words,
                borderRadius: 20,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  setState(() {
                    companyName = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company name';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                width: width,
                controller: positionController,
                labelText: "Position",
                hintText: "Position",
                prefixIcon: Icons.work_outline_rounded,
                textCapitalization: TextCapitalization.sentences,
                borderRadius: 20,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    position = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter position';
                  }
                  return null;
                },
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      errorText: typeError == "" ? null : typeError,
                      labelText: 'Job Type',
                      hintText: 'Job Type',
                      prefixIcon: const Icon(Icons.work_outline_rounded),
                    ),
                    controller: typeController,
                  ),
                  suggestionsCallback: (pattern) {
                    List<String> matches = <String>[];
                    matches.addAll(types);
                    matches.retainWhere((s) {
                      return s.toLowerCase().contains(pattern.toLowerCase());
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
                      type = suggestion.toString();
                    });
                  },
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                width: width,
                child: GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1990, 1),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != DateTime.now()) {
                      setState(() {
                        startDate = picked.toString().substring(0, 10);
                        startDateController.text = startDate;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: startDateController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_today),
                        labelText: "Start Date",
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
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
                    value: isCurrentlyWorking,
                    onChanged: (value) {
                      setState(() {
                        isCurrentlyWorking = value!;
                      });
                    },
                  ),
                  const Text("Currently Working"),
                ],
              ),
              isCurrentlyWorking
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8.0),
                      width: width,
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
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
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
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
              CustomTextFormField(
                width: width,
                controller: descriptionController,
                labelText: "Description",
                hintText: "Description",
                prefixIcon: Icons.description,
                textCapitalization: TextCapitalization.sentences,
                borderRadius: 20,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    description = value!;
                  });
                },
              ),
              CustomTextFormField(
                width: width,
                controller: salaryController,
                labelText: "Salary",
                hintText: "Salary",
                prefixIcon: Icons.money,
                textCapitalization: TextCapitalization.none,
                borderRadius: 20,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    salary = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter salary';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
