import 'package:gocv/apis/api.dart';
import 'package:gocv/apis/experience.dart';
import 'package:gocv/models/experience.dart';
import 'package:gocv/pages/work_experience/AddEditWorkExperiencePage.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:gocv/utils/urls.dart';

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

  List<Experience> experienceList = [];

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
    APIService()
        .sendGetRequest(accessToken, '${URLS.kExperienceUrl}$resumeId/')
        .then((data) async {
      if (data['status'] == 200) {
        print(data['data']);
        setState(() {
          experienceList = data['data']['data']
              .map<Experience>((experience) => Experience.fromJson(experience))
              .toList();
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
              return AddEditWorkExperiencePage(
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
                          fontSize: 22,
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
                                experienceList[index].id.toString(),
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
                                        Icons.work_outline_rounded,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: width * 0.7,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${experienceList[index].position}  - ${experienceList[index].type}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
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
                                                      .companyName ??
                                                  '',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            experienceList[index]
                                                        .companyWebsite !=
                                                    null
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Helper().launchInBrowser(
                                                            experienceList[
                                                                        index]
                                                                    .companyWebsite ??
                                                                '');
                                                      },
                                                      child: const Icon(
                                                        Icons.open_in_new,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
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
                                        child: experienceList[index].endDate ==
                                                null
                                            ? Text(
                                                '${Helper().formatMonthYear(experienceList[index].startDate ?? '')} - Present',
                                              )
                                            : Text(
                                                '${Helper().formatMonthYear(experienceList[index].startDate ?? '')} - ${Helper().formatMonthYear(experienceList[index].endDate ?? '')}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  experienceList[index].description == null
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
                                                        .description ??
                                                    '',
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

  void _showBottomSheet(BuildContext context, String experienceId) {
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
                    return AddEditWorkExperiencePage(
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
                  Navigator.of(context).pop(false);

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
          Helper().showSnackBar(
            context,
            'Experience deleted successfully',
            Colors.green,
          );
          fetchWorkExperiences(tokens['access'], widget.resumeId);
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
