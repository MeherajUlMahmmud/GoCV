import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gocv/models/skill.dart';
import 'package:gocv/repositories/skill.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
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
  SkillRepository skillRepository = SkillRepository();

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

  Skill skill = Skill(
    id: 0,
    resume: 0,
    name: '',
  );

  Map<String, dynamic> skillData = {
    'resume': '',
    'name': '',
    'proficiency': '',
    'description': '',
  };

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  void dispose() {
    skillController.dispose();
    proficiencyController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  fetchData() async {
    if (widget.skillId != null) {
      fetchSkillDetails(widget.skillId!);
    } else {
      skillData['resume'] = widget.resumeId;
      setState(() {
        isLoading = false;
        isError = false;
      });
    }
  }

  initiateControllers() {
    skillController.text = skillData['name'] = skill.name;
    proficiencyController.text =
        skillData['proficiency'] = skill.proficiency ?? '';
    descriptionController.text =
        skillData['description'] = skill.description ?? '';

    skillData['resume'] = skill.resume.toString();

    setState(() {
      isLoading = false;
      isError = false;
    });
  }

  fetchSkillDetails(String skillId) async {
    try {
      final response = await skillRepository.getSkillDetails(skillId);

      if (response['status'] == Constants.httpOkCode) {
        setState(() {
          skill = Skill.fromJson(response['data']);
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
        errorText = 'Error fetching skill details: $error';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
      Navigator.pop(context);
    }
  }

  createSkill() async {
    try {
      final response = await skillRepository.createSkill(skillData);

      if (response['status'] == Constants.httpCreatedCode) {
        setState(() {
          isLoading = false;
          isError = false;
        });

        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Skill created successfully',
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
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  updateSkill(String skillId) async {
    try {
      final response = await skillRepository.updateSkill(
        skillId,
        skillData,
      );

      if (response['status'] == Constants.httpOkCode) {
        setState(() {
          isLoading = false;
          isError = false;
        });

        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Skill details updated',
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
        errorText = 'Error updating skill details: $error';
      });
      if (!mounted) return;
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
    if (widget.skillId != null) {
      await updateSkill(widget.skillId!);
    } else {
      await createSkill();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.skillId == null ? 'Create New Skill' : 'Update Skill',
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
          text: widget.skillId == null ? 'Add Skill' : 'Update Skill',
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
                  controller: skillController,
                  labelText: 'Skill',
                  hintText: 'Skill',
                  prefixIcon: Icons.business,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      skillData['name'] = value!;
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
                        skillData['proficiency'] = suggestion.toString();
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
                      skillData['description'] = value;
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
