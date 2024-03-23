import 'package:flutter/material.dart';
import 'package:gocv/repositories/interest.dart';
import 'package:gocv/widgets/custom_button.dart';
import 'package:gocv/widgets/custom_text_form_field.dart';

class AddEditInterestPage extends StatefulWidget {
  final String resumeId;
  String? interestId;

  AddEditInterestPage({
    Key? key,
    required this.resumeId,
    this.interestId,
  }) : super(key: key);

  @override
  State<AddEditInterestPage> createState() => _AddEditInterestPageState();
}

class _AddEditInterestPageState extends State<AddEditInterestPage> {
  InterestRepository interestRepository = InterestRepository();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  TextEditingController interestController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  int id = 0;
  String uuid = '';
  String interest = '';
  String description = '';

  @override
  void initState() {
    super.initState();

    if (widget.interestId != null) {
      getInterest(widget.interestId!);
    } else {
      setState(() {
        isLoading = false;
        isError = false;
      });
    }
  }

  @override
  void dispose() {
    interestController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  getInterest(String interestId) {
    // final String url = '${URLS.kInterestUrl}${interestId}/details/';

    // APIService().sendGetRequest(accessToken, url).then((data) {
    //   print(data);
    //   if (data['status'] == Constants.HTTP_OK) {
    //     setState(() {
    //       isLoading = false;
    //       isError = false;
    //       uuid = data['data']['uuid'];
    //       interest = data['data']['interest'];
    //       description = data['data']['description'];
    //       interestController.text = interest;
    //       descriptionController.text = description;
    //     });
    //   } else {
    //     if (Helper().isUnauthorizedAccess(data['status'])) {
    //       Helper().showSnackBar(
    //         context,
    //         Constants.SESSION_EXPIRED_MSG,
    //         Colors.red,
    //       );
    //       Helper().logoutUser(context);
    //     } else {
    //       setState(() {
    //         isLoading = false;
    //         isError = true;
    //         errorText = data['error'];
    //       });
    //     }
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

  createInterest() {
    // Map<String, dynamic> data = {
    //   'interest': interest,
    //   'description': description,
    // };
    // final String url = '${URLS.kInterestUrl}${widget.resumeId}/create/';

    // APIService().sendPostRequest(accessToken, data, url).then((value) {
    //   if (value['status'] == Constants.HTTP_CREATED) {
    //     Navigator.pop(context);
    //   } else {
    //     if (Helper().isUnauthorizedAccess(data['status'])) {
    //       Helper().showSnackBar(
    //         context,
    //         Constants.SESSION_EXPIRED_MSG,
    //         Colors.red,
    //       );
    //       Helper().logoutUser(context);
    //     } else {
    //       setState(() {
    //         isLoading = false;
    //         isError = true;
    //         errorText = value['error'];
    //       });
    //     }
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

  updateInterest() {
    // Map<String, dynamic> data = {
    //   'interest': interest,
    //   'description': description,
    // };
    // final String url = '${URLS.kInterestUrl}${widget.interestId}/update/';

    // APIService().sendPatchRequest(accessToken, data, url).then((data) async {
    //   if (data['status'] == Constants.HTTP_OK) {
    //     Navigator.pop(context);
    //   } else {
    //     if (Helper().isUnauthorizedAccess(data['status'])) {
    //       Helper().showSnackBar(
    //         context,
    //         Constants.SESSION_EXPIRED_MSG,
    //         Colors.red,
    //       );
    //       Helper().logoutUser(context);
    //     } else {
    //       setState(() {
    //         isLoading = false;
    //         isError = true;
    //         errorText = data['error'];
    //       });
    //     }
    //   }
    // });
  }

  handleSubmit() {
    setState(() {
      isLoading = true;
    });
    if (widget.interestId != null) {
      updateInterest();
    } else {
      createInterest();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: widget.interestId != null
            ? const Text('Update Interest')
            : const Text('Add Interest'),
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
          text: widget.interestId == null ? 'Add Interest' : 'Update Interest',
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
                  controller: interestController,
                  labelText: 'Interest',
                  hintText: 'Interest',
                  prefixIcon: Icons.interests_outlined,
                  textCapitalization: TextCapitalization.words,
                  borderRadius: 10,
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      interest = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter interest';
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
