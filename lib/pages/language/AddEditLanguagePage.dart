import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gocv/apis/language.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
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
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};
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

  int id = 0;
  String uuid = '';
  String language = '';
  String proficiency = '';
  String description = '';

  @override
  void initState() {
    super.initState();

    readTokensAndUser();
  }

  @override
  void dispose() {
    languageController.dispose();
    proficiencyController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  readTokensAndUser() async {
    tokens = await localStorage.readData('tokens');
    user = await localStorage.readData('user');

    if (widget.languageId != null) {
      LanguageService()
          .getLanguage(tokens['access'], widget.languageId!)
          .then((data) {
        print(data);
        if (data['status'] == 200) {
          setState(() {
            isLoading = false;
            isError = false;
            uuid = data['data']['uuid'];
            language = data['data']['language'];
            proficiency = data['data']['proficiency'];
            description = data['data']['description'];
            languageController.text = language;
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
    } else {
      setState(() {
        isLoading = false;
        isError = false;
      });
    }
  }

  createLanguage() {
    LanguageService()
        .createLanguage(
      tokens['access'],
      widget.resumeId,
      language,
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

  updateLanguage() {
    LanguageService()
        .updateLanguage(
      tokens['access'],
      uuid,
      language,
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
    if (widget.languageId != null) {
      updateLanguage();
    } else {
      createLanguage();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: widget.languageId == null
            ? const Text('Add Language')
            : const Text('Update Language'),
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
          text: widget.languageId == null ? 'Add Language' : 'Update Language',
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
                    textFieldConfiguration: TextFieldConfiguration(
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        // errorText: typeError == "" ? null : typeError,
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
