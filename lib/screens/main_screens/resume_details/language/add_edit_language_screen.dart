import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gocv/models/language.dart';
import 'package:gocv/repositories/language.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/widgets/custom_button.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';

class AddEditLanguagePage extends StatefulWidget {
  final String resumeId;
  String? languageId;

  AddEditLanguagePage({
    Key? key,
    required this.resumeId,
    this.languageId,
  }) : super(key: key);

  @override
  State<AddEditLanguagePage> createState() => _AddEditLanguagePageState();
}

class _AddEditLanguagePageState extends State<AddEditLanguagePage> {
  LanguageRepository languageRepository = LanguageRepository();

  List<String> proficiencyTypes = [
    'Basic',
    'Conversational',
    'Fluent',
    'Native',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  TextEditingController languageController = TextEditingController();
  TextEditingController proficiencyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Language language = Language(
    id: 0,
    resume: 0,
    name: '',
    proficiency: '',
    description: '',
  );

  Map<String, dynamic> languageData = {
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
    languageController.dispose();
    proficiencyController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  fetchData() async {
    if (widget.languageId != null) {
      getLanguageDetails(widget.languageId!);
    } else {
      languageData['resume'] = widget.resumeId;
      setState(() {
        isLoading = false;
        isError = false;
      });
    }
  }

  initiateControllers() {
    languageController.text = languageData['name'] = language.name;
    proficiencyController.text =
        languageData['proficiency'] = language.proficiency!;
    descriptionController.text =
        languageData['description'] = language.description!;

    languageData['resume'] = language.resume.toString();

    setState(() {
      isLoading = false;
      isError = false;
    });
  }

  getLanguageDetails(String educationId) async {
    try {
      final response = await languageRepository.getLanguageDetails(educationId);

      if (response['status'] == Constants.httpOkCode) {
        setState(() {
          language = Language.fromJson(response['data']);
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

  createLanguage() async {
    try {
      final response = await languageRepository.createLanguage(languageData);

      if (response['status'] == Constants.httpCreatedCode) {
        setState(() {
          isLoading = false;
          isError = false;
        });

        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Language created successfully',
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
        errorText = 'Error adding language details: $error';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  updateLanguage(String languageId) async {
    try {
      final response = await languageRepository.updateLanguage(
        languageId,
        languageData,
      );

      if (response['status'] == Constants.httpOkCode) {
        setState(() {
          isLoading = false;
          isError = false;
        });

        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Language updated successfully',
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
        errorText = 'Error updating language details: $error';
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
    if (widget.languageId != null) {
      await updateLanguage(widget.languageId!);
    } else {
      await createLanguage();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.languageId == null ? 'Add Language' : 'Update Language',
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
          text: widget.languageId == null ? 'Add Language' : 'Update Language',
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
                  controller: languageController,
                  labelText: 'Language',
                  hintText: 'Language',
                  prefixIcon: Icons.business,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      language = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter language';
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
                    controller: proficiencyController,
                    // textFieldConfiguration: TextFieldConfiguration(
                    //   style: const TextStyle(fontSize: 16),
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.all(Radius.circular(10)),
                    //     ),
                    //     // errorText: typeError == "" ? null : typeError,
                    //     labelText: 'Proficiency Type',
                    //     hintText: 'Proficiency Type',
                    //     prefixIcon: Icon(Icons.work_outline_rounded),
                    //   ),
                    //   controller: proficiencyController,
                    // ),
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
                    onSelected: (suggestion) {
                      setState(() {
                        proficiencyController.text = suggestion.toString();
                        languageData['proficiency'] = suggestion.toString();
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
                      languageData['description'] = value;
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
