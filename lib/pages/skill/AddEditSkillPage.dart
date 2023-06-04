import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gocv/apis/skill.dart';
import 'package:gocv/models/skill.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/widgets/custom_button.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';

class AddEditSkillPage extends StatefulWidget {
  final String resumeId;
  String? skillId;

  AddEditSkillPage({
    Key? key,
    required this.resumeId,
    this.skillId,
  }) : super(key: key);

  @override
  State<AddEditSkillPage> createState() => _AddEditSkillPageState();
}

class _AddEditSkillPageState extends State<AddEditSkillPage> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};
  List<String> proficiencyTypes = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Professional',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isError = false;
  String errorText = '';
  String typeError = '';

  TextEditingController skillController = TextEditingController();
  TextEditingController proficiencyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  int id = 0;
  String uuid = '';
  String skill = '';
  String proficiency = '';
  String description = '';

  @override
  void initState() {
    super.initState();

    readTokensAndUser();
  }

  @override
  void dispose() {
    skillController.dispose();
    proficiencyController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  readTokensAndUser() async {
    tokens = await localStorage.readData('tokens');
    user = await localStorage.readData('user');

    if (widget.skillId != null) {
      getSkill(tokens['access'], widget.skillId!);
    } else {
      setState(() {
        isLoading = false;
        isError = false;
      });
    }
  }

  getSkill(String accessToken, String skillId) {
    SkillService().getSkill(accessToken, skillId).then((data) {
      print(data);
      if (data['status'] == 200) {
        setState(() {
          isLoading = false;
          isError = false;
          uuid = data['data']['uuid'];
          skill = data['data']['skill'];
          proficiency = data['data']['proficiency'];
          description = data['data']['description'];
          skillController.text = skill;
          proficiencyController.text = proficiency;
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
  }

  createSkill() {
    SkillService()
        .createSkill(
      tokens['access'],
      widget.resumeId,
      skill,
      proficiency,
      description,
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

  updateSkill() {
    SkillService()
        .updateSkill(
      tokens['access'],
      uuid,
      skill,
      proficiency,
      description,
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
    if (widget.skillId != null) {
      updateSkill();
    } else {
      createSkill();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: widget.skillId == null
            ? const Text('Add Skill')
            : const Text('Update Skill'),
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
          text: widget.skillId == null ? 'Add Skill' : 'Update Skill',
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
                  controller: skillController,
                  labelText: 'Skill',
                  hintText: 'Skill',
                  prefixIcon: Icons.business,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      skill = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter skill';
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
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        errorText: typeError == '' ? null : typeError,
                        labelText: 'Proficiency Type',
                        hintText: 'Proficiency Type',
                        prefixIcon: const Icon(Icons.work_outline_rounded),
                      ),
                      controller: proficiencyController,
                    ),
                    suggestionsCallback: (pattern) {
                      List<String> matches = <String>[];
                      matches.addAll(proficiencyTypes);
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
                        proficiencyController.text = suggestion.toString();
                        proficiency = suggestion.toString();
                      });
                    },
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
