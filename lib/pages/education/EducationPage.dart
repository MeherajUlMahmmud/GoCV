import 'package:flutter/material.dart';
import 'package:gocv/apis/api.dart';
import 'package:gocv/apis/education.dart';
import 'package:gocv/pages/education/AddEditEducation.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/utils/urls.dart';

class EducationPage extends StatefulWidget {
  final String resumeId;
  const EducationPage({
    Key? key,
    required this.resumeId,
  }) : super(key: key);

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

  List<dynamic> educationList = [];

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

    fetchEducations(tokens['access'], widget.resumeId);
  }

  fetchEducations(String accessToken, String resumeId) {
    APIService()
        .sendGetRequest(accessToken, '${URLS.kEducationUrl}$resumeId/')
        .then((data) async {
      print(data);
      if (data['status'] == 200) {
        setState(() {
          educationList = data['data']['data'];
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
            'Failed to fetch educations',
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return AddEditEducationPage(
                resumeId: widget.resumeId,
              );
            }),
          );
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
              : educationList.isEmpty
                  ? const Center(
                      child: Text(
                        'No education added',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        fetchEducations(
                          tokens['access'],
                          widget.resumeId,
                        );
                      },
                      child: ListView.builder(
                        itemCount: educationList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                context,
                                educationList[index]['id'].toString(),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
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
                                        Icons.business,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: width * 0.7,
                                        child: Text(
                                          educationList[index]['school_name'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.business,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: width * 0.7,
                                        child: Text(
                                          educationList[index]['degree'] +
                                              ' in ' +
                                              educationList[index]
                                                  ['department'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.money,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: width * 0.7,
                                        child: Text(
                                          '${educationList[index]['grade']} out of ${educationList[index]['grade_scale']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.date_range,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: width * 0.7,
                                        child: Text(
                                          educationList[index]['start_date'] ==
                                                  null
                                              ? ''
                                              : '${Helper().formatMonthYear(educationList[index]['start_date'])} - ' +
                                                          educationList[index]
                                                              ['end_date'] ==
                                                      null
                                                  ? ''
                                                  : Helper().formatMonthYear(
                                                      educationList[index]
                                                          ['end_date']),
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  educationList[index]['description'] == null ||
                                          educationList[index]['description'] ==
                                              ''
                                      ? const SizedBox()
                                      : Row(
                                          children: [
                                            const Icon(
                                              Icons.description,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              width: width * 0.7,
                                              child: Text(
                                                educationList[index]
                                                    ['description'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
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

  void _showBottomSheet(BuildContext context, String educationId) {
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
                    return AddEditEducationPage(
                      resumeId: widget.resumeId,
                      educationId: educationId,
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
                  _showDeleteConfirmationDialog(context, educationId);
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
    String educationId,
  ) {
    deleteEducation() {
      EducationService()
          .deleteEducation(tokens['access'], educationId)
          .then((data) async {
        if (data['status'] == 200) {
          Navigator.of(context).pop();
          Helper().showSnackBar(
            context,
            'Education deleted successfully',
            Colors.green,
          );
          fetchEducations(tokens['access'], widget.resumeId);
        } else {
          if (data['status'] == 401 || data['status'] == 403) {
            Helper().showSnackBar(
              context,
              'Session expired',
              Colors.red,
            );
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          } else {
            Helper().showSnackBar(
              context,
              'Failed to delete education',
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
                deleteEducation();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
