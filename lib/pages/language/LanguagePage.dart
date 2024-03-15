import 'package:flutter/material.dart';
import 'package:gocv/models/language.dart';
import 'package:gocv/pages/language/AddEditLanguagePage.dart';
import 'package:gocv/repositories/language.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';

class LanguagePage extends StatefulWidget {
  final String resumeId;

  const LanguagePage({
    Key? key,
    required this.resumeId,
  }) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  LanguageRepository languageRepository = LanguageRepository();

  List<Language> languageList = [];

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  @override
  void initState() {
    super.initState();

    fetchLanguages(widget.resumeId);
  }

  fetchLanguages(String resumeId) async {
    Map<String, dynamic> params = {
      'resume_id': resumeId,
    };
    try {
      final response = await languageRepository.getLanguages(resumeId, params);

      if (response['status'] == Constants.httpOkCode) {
        final List<Language> fetchedLanguages =
            (response['data']['data'] as List)
                .map((data) => Language.fromJson(data))
                .toList();

        setState(() {
          languageList = fetchedLanguages;
          isLoading = false;
          isError = false;
          errorText = '';
        });
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
            errorText = response['message'];
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
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorText = 'Error fetching data: $error';
      });
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return AddEditLanguagePage(
                resumeId: widget.resumeId,
              );
            },
          ));
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
              ? Center(
                  child: Text(
                    errorText,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  ),
                )
              : languageList.isEmpty
                  ? const Center(
                      child: Text(
                        'No languages added',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        fetchLanguages(widget.resumeId);
                      },
                      child: ListView.builder(
                        itemCount: languageList.length,
                        itemBuilder: (context, index) {
                          return languageItem(context, index, width);
                        },
                      ),
                    ),
    );
  }

  Widget languageItem(BuildContext context, int index, double width) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.language,
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: width * 0.7,
                child: Text(
                  '${languageList[index].name} - ${languageList[index].proficiency!}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddEditLanguagePage(
                              resumeId: widget.resumeId,
                              languageId: languageList[index].id.toString(),
                            );
                          },
                        ),
                      );
                    },
                    value: 'update',
                    child: const Text('Update'),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Language?'),
                            content: const Text(
                              'Are you sure you want to delete this language?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // await deleteLanguage(
                                  //   languageList[index].id.toString(),
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
                    value: 'delete',
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          languageList[index].description == null ||
                  languageList[index].description == ''
              ? const SizedBox()
              : Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.description,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: width * 0.7,
                        child: Text(
                          languageList[index].description ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
