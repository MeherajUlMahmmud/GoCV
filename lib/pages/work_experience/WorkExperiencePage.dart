import 'package:gocv/models/experience.dart';
import 'package:gocv/pages/work_experience/AddEditWorkExperiencePage.dart';
import 'package:gocv/repositories/experience.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
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
  ExperienceRepository experienceRepository = ExperienceRepository();

  List<Experience> experienceList = [];

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  @override
  void initState() {
    super.initState();

    fetchWorkExperiences(widget.resumeId);
  }

  fetchWorkExperiences(String resumeId) async {
    Map<String, dynamic> params = {
      'resume_id': resumeId,
    };
    try {
      final response = await experienceRepository.getExperiences(
        resumeId,
        params,
      );

      if (response['status'] == Constants.httpOkCode) {
        final List<Experience> fetchedExperiences = (response['data']['data']
                as List)
            .map<Experience>((experience) => Experience.fromJson(experience))
            .toList();
        setState(() {
          experienceList = fetchedExperiences;
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
        isError = true;
        errorText = 'Error fetching work experiences: $error';
      });
      if (!mounted) return;
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  deleteWorkExperience(String experienceId) async {
    try {
      final response = await experienceRepository.deleteExperience(
        experienceId,
      );

      if (response['status'] == Constants.httpNoContentCode) {
        setState(() {
          experienceList.removeWhere(
            (experience) => experience.id.toString() == experienceId,
          );
          isError = false;
        });

        if (!mounted) return;
        Helper().showSnackBar(
          context,
          'Experience deleted successfully',
          Colors.green,
        );
        Navigator.pop(context);
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
        errorText = 'Error deleting experience: $error';
      });
      if (!mounted) return;
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
      backgroundColor: Colors.white,
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
                        fetchWorkExperiences(widget.resumeId);
                      },
                      child: ListView.builder(
                        itemCount: experienceList.length,
                        itemBuilder: (context, index) {
                          return ExperienceItem(
                            widget: widget,
                            experienceList: experienceList,
                            index: index,
                            width: width,
                            onDelete: () {
                              deleteWorkExperience(
                                experienceList[index].id.toString(),
                              );
                            },
                          );
                        },
                      ),
                    ),
    );
  }
}

class ExperienceItem extends StatelessWidget {
  const ExperienceItem({
    super.key,
    required this.widget,
    required this.experienceList,
    required this.index,
    required this.width,
    required this.onDelete,
  });

  final WorkExperiencePage widget;
  final List<Experience> experienceList;
  final int index;
  final double width;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
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
        color: experienceList[index].isActive!
            ? Colors.white
            : Colors.grey.shade200,
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
                Icons.work_outline_rounded,
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  SizedBox(
                    width: width * 0.7,
                    child: Text(
                      '${experienceList[index].position} - ${experienceList[index].type}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AddEditWorkExperiencePage(
                                resumeId: widget.resumeId,
                                experienceId:
                                    experienceList[index].id.toString(),
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
                              title: const Text('Delete Experience'),
                              content: const Text(
                                'Are you sure you want to delete this experience?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    onDelete();
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
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.business,
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: width * 0.8,
                child: Row(
                  children: [
                    SizedBox(
                      width: width * 0.7,
                      child: Text(
                        experienceList[index].companyName,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    experienceList[index].companyWebsite != null
                        ? Container(
                            margin: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Helper().launchInBrowser(
                                    experienceList[index].companyWebsite!);
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
                width: width * 0.8,
                child: Helper().isNullEmptyOrFalse(
                  experienceList[index].endDate,
                )
                    ? Text(
                        '${Helper().formatMonthYear(experienceList[index].startDate)} - Present',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        '${Helper().formatMonthYear(experienceList[index].startDate)} - ${Helper().formatMonthYear(experienceList[index].endDate ?? '')}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Helper().isNullEmptyOrFalse(
            experienceList[index].description,
          )
              ? const SizedBox()
              : Row(
                  children: [
                    const Icon(
                      Icons.description,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: width * 0.8,
                      child: Text(
                        experienceList[index].description!,
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
