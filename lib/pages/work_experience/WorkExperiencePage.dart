import 'package:gocv/apis/experience.dart';
import 'package:gocv/pages/work_experience/AddWorkExperiencePage.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:flutter/material.dart';

class WorkExperiencePage extends StatefulWidget {
  final String resumeId;
  const WorkExperiencePage({
    Key? key,
    required this.resumeId,
  }) : super(key: key);

  @override
  State<WorkExperiencePage> createState() => _WorkExperiencePageState();
}

class _WorkExperiencePageState extends State<WorkExperiencePage> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

  List<dynamic> experienceList = [];

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

    fetchWorkExperiences(tokens['access'], widget.resumeId);
  }

  fetchWorkExperiences(String accessToken, String resumeId) {
    ExpreienceService()
        .getExperienceList(accessToken, resumeId)
        .then((data) async {
      if (data['status'] == 200) {
        setState(() {
          experienceList = data['data'];
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
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return AddWorkExperiencePage(
                resumeId: widget.resumeId,
              );
            },
          ));
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
              : experienceList.isEmpty
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
                        fetchWorkExperiences(
                          tokens['access'],
                          widget.resumeId,
                        );
                      },
                      child: ListView.builder(
                        itemCount: experienceList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                context,
                                experienceList[index]['uuid'],
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
                                        Icons.work_outline_rounded,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: width * 0.7,
                                        child: Text(
                                          experienceList[index]['position'] +
                                              ' - ' +
                                              experienceList[index]['type'],
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
                                        child: Row(
                                          children: [
                                            Text(
                                              experienceList[index]
                                                  ['company_name'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            experienceList[index][
                                                            'company_website'] ==
                                                        null ||
                                                    experienceList[index][
                                                            'company_website'] ==
                                                        ''
                                                ? const SizedBox()
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Helper().launchInBrowser(
                                                            experienceList[
                                                                    index][
                                                                'company_website']);
                                                      },
                                                      child: const Icon(
                                                        Icons.open_in_new,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // Row(
                                  //   children: [
                                  //     const Icon(
                                  //       Icons.money,
                                  //       color: Colors.grey,
                                  //     ),
                                  //     const SizedBox(width: 10),
                                  //     SizedBox(
                                  //       width: width * 0.7,
                                  //       child: Text(
                                  //         '${experienceList[index]['salary']} BDT',
                                  //         style: const TextStyle(
                                  //           fontSize: 18,
                                  //           color: Colors.green,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.date_range,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: width * 0.7,
                                        child: experienceList[index]
                                                    ['end_date'] ==
                                                null
                                            ? Text(
                                                '${Helper().formatDate(experienceList[index]['start_date'])} - Present',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              )
                                            : Text(
                                                '${Helper().formatDate(experienceList[index]['start_date'])} - ${Helper().formatDate(experienceList[index]['end_date'])}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  experienceList[index]['description'] ==
                                              null ||
                                          experienceList[index]
                                                  ['description'] ==
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
                                                experienceList[index]
                                                    ['description'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.justify,
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

  void _showBottomSheet(
    BuildContext context,
    String experienceId,
  ) {
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
                    return AddWorkExperiencePage(
                      resumeId: widget.resumeId,
                      experienceId: experienceId,
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
                  _showDeleteConfirmationDialog(context, experienceId);
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

  void _showDeleteConfirmationDialog(
    BuildContext context,
    String experienceId,
  ) {
    deleteExperience() {
      ExpreienceService()
          .deleteExperience(tokens['access'], experienceId)
          .then((data) async {
        if (data['status'] == 200) {
          Navigator.of(context).pop(true);
          Navigator.of(context).pop(true);
          Helper().showSnackBar(
            context,
            'Experience deleted successfully',
            Colors.green,
          );
          fetchWorkExperiences(
            tokens['access'],
            widget.resumeId,
          );
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
              'Failed to delete experience',
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
                deleteExperience();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
