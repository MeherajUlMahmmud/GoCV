import 'package:flutter/material.dart';
import 'package:gocv/apis/api.dart';
import 'package:gocv/pages/language/AddEditLanguagePage.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/utils/urls.dart';

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
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

  List<dynamic> languageList = [];

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  @override
  void initState() {
    super.initState();

    readTokensAndUser();
  }

  readTokensAndUser() async {
    tokens = await localStorage.readData('tokens');
    user = await localStorage.readData('user');

    fetchLanguages(tokens['access'], widget.resumeId);
  }

  fetchLanguages(String accessToken, String resumeId) {
    String url = '${URLS.kLanguageUrl}$resumeId/list/';
    APIService()
        .sendGetRequest(
      accessToken,
      url,
    )
        .then((data) async {
      if (data['status'] == 200) {
        setState(() {
          languageList = data['data']['data'];
          isLoading = false;
          isError = false;
          errorText = '';
        });
      } else {
        if (data['status'] == 401 || data['status'] == 403) {
          Helper().showSnackBar(
            context,
            'Session expired',
            Colors.red,
          );
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        } else {
          print(data['error']);
          setState(() {
            isLoading = false;
            isError = true;
            errorText = data['error'];
          });
          Helper().showSnackBar(
            context,
            'Failed to fetch languages',
            Colors.red,
          );
        }
      }
    });
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
                        fetchLanguages(
                          tokens['access'],
                          widget.resumeId,
                        );
                      },
                      child: ListView.builder(
                        itemCount: languageList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                context,
                                languageList[index]['uuid'],
                              );
                            },
                            child: Container(
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
                                          languageList[index]['language'] +
                                              ' - ' +
                                              languageList[index]
                                                  ['proficiency'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  languageList[index]['description'] == null ||
                                          languageList[index]['description'] ==
                                              ''
                                      ? const SizedBox()
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
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
                                                  languageList[index]
                                                      ['description'],
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
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  void _showBottomSheet(BuildContext context, String languageId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddEditLanguagePage(
                      resumeId: widget.resumeId,
                      languageId: languageId,
                    );
                  }));
                },
                child: const Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8.0),
                    Text('Update'),
                  ],
                ),
              ),
              const Divider(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showDeleteConfirmationDialog(context, languageId);
                },
                child: const Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 8.0),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    String languageId,
  ) {
    void deleteLanguage() {
      APIService()
          .sendDeleteRequest(
        tokens['access'],
        '${URLS.kLanguageUrl}${widget.resumeId}/delete/',
      )
          .then((data) async {
        print(data);
        if (data['status'] == 204) {
          Navigator.of(context).pop();
          Helper().showSnackBar(
            context,
            'Language deleted successfully',
            Colors.green,
          );
          // fetchLanguages(tokens['access'], widget.resumeId);
        } else {
          if (data['status'] == 401 || data['status'] == 403) {
            Helper().showSnackBar(
              context,
              'Session expired',
              Colors.red,
            );
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          } else {
            print(data['error']);
            Helper().showSnackBar(
              context,
              'Failed to delete language',
              Colors.red,
            );
          }
        }
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteLanguage();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
