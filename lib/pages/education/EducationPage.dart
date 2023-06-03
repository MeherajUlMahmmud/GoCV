import 'package:flutter/material.dart';
import 'package:gocv/apis/education.dart';
import 'package:gocv/pages/education/AddEditEducation.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';

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
    EducationService()
        .getEducationList(accessToken, resumeId)
        .then((data) async {
      print(data);
      if (data['status'] == 200) {
        setState(() {
          educationList = data['data'];
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
            'Failed to fetch work experiences',
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
          ? const CircularProgressIndicator()
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
                        'No work experiences added',
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
                                educationList[index]['uuid'],
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                                vertical: 10,
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
                                        child: educationList[index]
                                                        ['start_date'] !=
                                                    null &&
                                                educationList[index]
                                                        ['end_date'] ==
                                                    null
                                            ? Text(
                                                '${Helper().formatMonthYear(educationList[index]['start_date'])} - Present',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              )
                                            : educationList[index]
                                                            ['start_date'] ==
                                                        null &&
                                                    educationList[index]
                                                            ['end_date'] !=
                                                        null
                                                ? Text(
                                                    Helper().formatMonthYear(
                                                        educationList[index]
                                                            ['end_date']),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  )
                                                : const SizedBox(),
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
                                                  fontSize: 18,
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
                  Navigator.of(context).pop(false);

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddEditEducationPage(
                      resumeId: widget.resumeId,
                      educationId: educationId,
                    );
                  }));
                },
                child: Row(
                  children: const [
                    Icon(Icons.edit),
                    SizedBox(width: 8.0),
                    Text('Update'),
                  ],
                ),
              ),
              const Divider(),
              TextButton(
                onPressed: () {
                  // _showDeleteConfirmationDialog(context, experienceId);
                },
                child: Row(
                  children: const [
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
}