import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gocv/models/education.dart';
import 'package:gocv/screens/main_screens/resume_details/education/add_edit_education_screen.dart';
import 'package:gocv/repositories/education.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';

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
  EducationRepository educationRepository = EducationRepository();

  List<Education> educationList = [];

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  @override
  void initState() {
    super.initState();

    fetchEducations(widget.resumeId);
  }

  fetchEducations(String resumeId) async {
    Map<String, dynamic> params = {
      'resume_id': resumeId,
    };

    try {
      final response = await educationRepository.getEducations(
        widget.resumeId,
        params,
      );

      if (response['status'] == Constants.httpOkCode) {
        final List<Education> fetchedEducationList =
            (response['data']['data'] as List).map<Education>((education) {
          return Education.fromJson(education);
        }).toList();

        setState(() {
          educationList = fetchedEducationList;
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
            isError = true;
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
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error fetching education list: $error';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  updateSerial(String educationId, String newSerial) async {
    try {
      final response = await educationRepository.updateSerial(
        educationId,
        newSerial,
      );
      print(response);

      if (response['status'] == Constants.httpOkCode) {
        setState(() {
          isError = false;
        });

        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Education serial updated successfully',
          Colors.green,
        );
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
      print('Error updating education serial: $error');
      setState(() {
        isLoading = false;
        errorText = 'Error updating education serial: $error';
      });
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  deleteEducation(String educationId) async {
    try {
      final response = await educationRepository.deleteEducation(
        educationId,
      );

      if (response['status'] == Constants.httpNoContentCode) {
        setState(() {
          educationList.removeWhere(
            (education) => education.id.toString() == educationId,
          );
          isError = false;
        });

        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Education deleted successfully',
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
      setState(() {
        isLoading = false;
        errorText = 'Error deleting education details: $error';
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

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color draggableItemColor = colorScheme.secondary;

    Widget proxyDecorator(
        Widget child, int index, Animation<double> animation) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          final double animValue = Curves.easeInOut.transform(animation.value);
          final double elevation = lerpDouble(0, 6, animValue)!;
          return Material(
            elevation: elevation,
            color: draggableItemColor,
            shadowColor: draggableItemColor,
            child: child,
          );
        },
        child: child,
      );
    }

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
                          fontSize: 22,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        fetchEducations(widget.resumeId);
                      },
                      child: ReorderableListView(
                        proxyDecorator: proxyDecorator,
                        onReorder: (int oldIndex, int newIndex) async {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          await updateSerial(
                            educationList[oldIndex].id.toString(),
                            (newIndex + 1).toString(),
                          );
                          setState(() {
                            final Education item =
                                educationList.removeAt(oldIndex);
                            educationList.insert(newIndex, item);
                          });
                        },
                        children: [
                          for (int index = 0;
                              index < educationList.length;
                              index++)
                            ReorderableDragStartListener(
                              index: index,
                              key: ValueKey(educationList[index]),
                              child: educationItem(
                                index,
                                width,
                              ),
                            ),
                        ],
                      ),
                    ),
    );
  }

  Widget educationItem(int index, double width) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.business,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: width * 0.7,
                child: Text(
                  educationList[index].schoolName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AddEditEducationPage(
                                resumeId: widget.resumeId,
                                educationId: educationList[index].id.toString(),
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
                              title: const Text('Delete Education'),
                              content: const Text(
                                'Are you sure you want to delete this education?',
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
                                    await deleteEducation(
                                      educationList[index].id.toString(),
                                    );
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
                  ];
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.business,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: width * 0.8,
                child: Text(
                  '${educationList[index].degree!} in ${educationList[index].department!}',
                  style: const TextStyle(
                    fontSize: 18,
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
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: width * 0.8,
                child: Text(
                  '${educationList[index].grade!} out of ${educationList[index].gradeScale!}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Helper().isNullEmptyOrFalse(educationList[index].startDate)
              ? const SizedBox()
              : Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: width * 0.8,
                      child: Helper()
                              .isNullEmptyOrFalse(educationList[index].endDate)
                          ? Text(
                              '${Helper().formatMonthYear(educationList[index].startDate)} - Present',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            )
                          : Text(
                              '${Helper().formatMonthYear(educationList[index].startDate)} - ${Helper().formatMonthYear(educationList[index].endDate ?? '')}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ],
                ),
          const SizedBox(height: 10),
          Helper().isNullEmptyOrFalse(educationList[index].description)
              ? const SizedBox()
              : Row(
                  children: [
                    const Icon(
                      Icons.description,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: width * 0.7,
                      child: Text(
                        educationList[index].description!,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
