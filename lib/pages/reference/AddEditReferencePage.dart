import 'package:flutter/material.dart';
import 'package:gocv/models/reference.dart';
import 'package:gocv/repositories/reference.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
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
  ReferenceRepository referenceRepository = ReferenceRepository();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isError = false;
  String errorText = '';
  String typeError = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Reference reference = Reference(
    id: 0,
    resume: 0,
    name: '',
    email: '',
    phone: '',
    companyName: '',
    position: '',
    description: '',
  );

  Map<String, dynamic> referenceData = {
    'name': '',
    'email': '',
    'phone': '',
    'company_name': '',
    'position': '',
    'description': '',
  };

  @override
  void initState() {
    super.initState();

    fetchData();
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

  fetchData() async {
    if (widget.referenceId != null) {
      getReferenceDetails(widget.referenceId!);
    } else {
      referenceData['resume'] = widget.resumeId;

      setState(() {
        isLoading = false;
        isError = false;
      });
    }
  }

  initiateControllers() {
    nameController.text = referenceData['name'] = reference.name;
    emailController.text = referenceData['email'] = reference.email;
    phoneController.text = referenceData['phone'] = reference.phone ?? '';
    companyNameController.text =
        referenceData['company_name'] = reference.companyName ?? '';
    positionController.text =
        referenceData['position'] = reference.position ?? '';
    descriptionController.text =
        referenceData['description'] = reference.description ?? '';

    referenceData['resume'] = widget.resumeId;

    setState(() {
      isLoading = false;
      isError = false;
    });
  }

  getReferenceDetails(String referenceId) async {
    try {
      final response = await referenceRepository.getReferenceDetails(
        referenceId,
      );

      if (response['status'] == Constants.httpOkCode) {
        setState(() {
          reference = Reference.fromJson(response['data']);
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
        errorText = 'Error fetching reference details: $error';
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

  createReference() async {
    try {
      print(referenceData);
      final response = await referenceRepository.createReference(referenceData);
      print(response);

      if (response['status'] == Constants.httpCreatedCode) {
        setState(() {
          isLoading = false;
          isError = false;
        });

        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Reference added successfully',
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
        errorText = 'Error adding reference details: $error';
      });
      print('Error adding reference details: $error');
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  updateReference(String referenceId) async {
    try {
      final response = await referenceRepository.updateReference(
        referenceId,
        referenceData,
      );

      if (response['status'] == Constants.httpOkCode) {
        setState(() {
          isLoading = false;
          isError = false;
        });

        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Reference updated successfully',
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
        errorText = 'Error updating reference details: $error';
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
    if (widget.referenceId != null) {
      await updateReference(widget.referenceId!);
    } else {
      await createReference();
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
          widget.referenceId == null ? 'Add Reference' : 'Update Reference',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
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
          text:
              widget.referenceId == null ? 'Add Reference' : 'Update Reference',
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
                  controller: nameController,
                  labelText: 'Name',
                  hintText: 'Name',
                  prefixIcon: Icons.business,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      referenceData['name'] = value!;
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
                      referenceData['email'] = value!;
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
                      referenceData['phone'] = value!;
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
                      referenceData['company_name'] = value!;
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
                      referenceData['position'] = value;
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
                      referenceData['description'] = value;
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
