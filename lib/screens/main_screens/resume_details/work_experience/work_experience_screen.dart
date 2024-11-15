import 'package:flutter/material.dart';
import 'package:gocv/models/experience.dart';
import 'package:gocv/screens/main_screens/resume_details/work_experience/add_edit_work_experience_screen.dart';
import 'package:gocv/providers/experience_list_provider.dart';
import 'package:gocv/repositories/experience.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
import 'package:provider/provider.dart';

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

  late ExperienceListProvider experienceListProvider;

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  @override
  void initState() {
    super.initState();

    experienceListProvider = Provider.of<ExperienceListProvider>(
      context,
      listen: false,
    );

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
        experienceListProvider.setExperienceList(fetchedExperiences);
        setState(() {
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
        experienceListProvider.removeExperience(
          experienceListProvider.experienceList.firstWhere(
              (experience) => experience.id.toString() == experienceId),
        );
        setState(() {
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
              : experienceListProvider.experienceList.isEmpty
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
                        itemCount: experienceListProvider.experienceList.length,
                        itemBuilder: (context, index) {
                          return experienceItem(
                            index,
                            width,
                          );
                        },
                      ),
                    ),
    );
  }

  Widget experienceItem(int index, double width) {
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
        // color: experienceListProvider.experienceList[index].isActive!
        //     ? Colors.white
        //     : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.work_outline_rounded,
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  SizedBox(
                    width: width * 0.7,
                    child: Text(
                      '${experienceListProvider.experienceList[index].position} - ${experienceListProvider.experienceList[index].type}',
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
                icon: const Icon(Icons.more_vert),
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
                                experienceId: experienceListProvider
                                    .experienceList[index].id
                                    .toString(),
                              );
                            },
                          ),
                        );
                      },
                      value: 'update',
                      child: const Row(
                        children: [
                          Icon(
                            Icons.edit,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Update',
                            style: TextStyle(
                            ),
                          ),
                        ],
                      ),
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
                                  onPressed: () async {
                                    await deleteWorkExperience(
                                      experienceListProvider
                                          .experienceList[index].id
                                          .toString(),
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
                      child: const Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    experienceListProvider.experienceList[index].isActive ==
                            true
                        ? PopupMenuItem(
                            onTap: () {},
                            value: 'hide',
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.visibility_off,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Hide',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : PopupMenuItem(
                            onTap: () {},
                            value: 'show',
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.visibility,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 5),
                                Text('Show'),
                              ],
                            ),
                          ),
                  ];
                },
              ),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.business,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: width * 0.8,
                child: Row(
                  children: [
                    SizedBox(
                      width: width * 0.7,
                      child: Text(
                        experienceListProvider
                            .experienceList[index].companyName,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Helper().isNullEmptyOrFalse(experienceListProvider
                            .experienceList[index].companyWebsite)
                        ? const SizedBox()
                        : Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                Helper().launchInBrowser(experienceListProvider
                                    .experienceList[index].companyWebsite!);
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
          Row(
            children: [
              const Icon(
                Icons.date_range,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: width * 0.8,
                child: Helper().isNullEmptyOrFalse(
                  experienceListProvider.experienceList[index].endDate,
                )
                    ? Text(
                        '${Helper().formatMonthYear(experienceListProvider.experienceList[index].startDate)} - Present',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      )
                    : Text(
                        '${Helper().formatMonthYear(experienceListProvider.experienceList[index].startDate)} - ${Helper().formatMonthYear(experienceListProvider.experienceList[index].endDate ?? '')}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Helper().isNullEmptyOrFalse(
            experienceListProvider.experienceList[index].description,
          )
              ? const SizedBox()
              : Row(
                  children: [
                    const Icon(
                      Icons.description,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: width * 0.8,
                      child: Text(
                        experienceListProvider
                            .experienceList[index].description!,
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
