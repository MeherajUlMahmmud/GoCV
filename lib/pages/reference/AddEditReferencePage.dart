import 'package:flutter/material.dart';
import 'package:gocv/apis/api.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/utils/urls.dart';
import 'package:gocv/widgets/custom_button.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';

class AddEditReferencePage extends StatefulWidget {
  final String resumeId;
  String? referenceId;

  AddEditReferencePage({
    Key? key,
    required this.resumeId,
    this.referenceId,
  }) : super(key: key);

  @override
  State<AddEditReferencePage> createState() => _AddEditReferencePageState();
}

class _AddEditReferencePageState extends State<AddEditReferencePage> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  int id = 0;
  String uuid = '';
  String name = '';
  String email = '';
  String phone = '';
  String companyName = '';
  String position = '';
  String description = '';

  String typeError = '';

  @override
  void initState() {
    super.initState();

    readTokensAndUser();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    companyNameController.dispose();
    positionController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  readTokensAndUser() async {
    tokens = await localStorage.readData('tokens');
    user = await localStorage.readData('user');

    if (widget.referenceId != null) {
      APIService()
          .sendGetRequest(
        tokens['access'],
        '${URLS.kReferenceUrl}${widget.referenceId}/details/',
      )
          .then((data) {
        print(data);
        if (data['status'] == 200) {
          setState(() {
            isLoading = false;
            isError = false;
            uuid = data['data']['uuid'];
            name = data['data']['name'];
            email = data['data']['email'];
            phone = data['data']['phone'];
            companyName = data['data']['company_name'];
            position = data['data']['position'];
            description = data['data']['description'];
            nameController.text = name;
            emailController.text = email;
            phoneController.text = phone;
            companyNameController.text = companyName;
            positionController.text = position;
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

  createReference() {
    Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'phone': phone,
      'company_name': companyName,
      'position': position,
      'description': description,
    };
    APIService()
        .sendPostRequest(
      tokens['access'],
      data,
      '${URLS.kReferenceUrl}${widget.resumeId}/create/',
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

  updateReference() {
    Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'phone': phone,
      'company_name': companyName,
      'position': position,
      'description': description,
    };
    APIService()
        .sendPatchRequest(
      tokens['access'],
      data,
      '${URLS.kReferenceUrl}${widget.referenceId}/update/',
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
    if (widget.referenceId != null) {
      updateReference();
    } else {
      createReference();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: widget.referenceId == null
            ? const Text('Add Work Experience')
            : const Text('Update Work Experience'),
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
              widget.referenceId == null ? 'Add Reference' : 'Update Reference',
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
                  controller: nameController,
                  labelText: 'Name',
                  hintText: 'Name',
                  prefixIcon: Icons.business,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      name = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter referncee name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  width: width,
                  controller: emailController,
                  labelText: 'Email Address',
                  hintText: 'Email Address',
                  prefixIcon: Icons.email,
                  textCapitalization: TextCapitalization.none,
                  borderRadius: 10,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      email = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  width: width,
                  controller: phoneController,
                  labelText: 'Phone Number',
                  hintText: 'Phone Number',
                  prefixIcon: Icons.phone,
                  textCapitalization: TextCapitalization.none,
                  borderRadius: 10,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      phone = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  width: width,
                  controller: companyNameController,
                  labelText: 'Organization Name',
                  hintText: 'Organization Name',
                  prefixIcon: Icons.work_outline_rounded,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      companyName = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter organization name';
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
