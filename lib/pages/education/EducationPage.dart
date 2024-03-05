import 'package:flutter/material.dart';
import 'package:gocv/apis/api.dart';
import 'package:gocv/models/education.dart';
import 'package:gocv/pages/education/AddEditEducation.dart';
import 'package:gocv/repositories/education.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
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

  fetchEducations(String resumeId) {
    // final String url = '${URLS.kEducationUrl}$resumeId/list/';

    // APIService().sendGetRequest(accessToken, url).then((data) async {
    //   if (data['status'] == Constants.HTTP_OK) {
    //     setState(() {
    //       educationList = data['data']['data'].map<Education>((education) {
    //         return Education.fromJson(education);
    //       }).toList();
    //       isLoading = false;
    //       isError = false;
    //       errorText = '';
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
    //       Helper().showSnackBar(
    //         context,
    //         'Failed to fetch educations',
    //         Colors.red,
    //       );
    //     }
    //   }
    // });
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
                      child: ListView.builder(
                        itemCount: educationList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AddEditEducationPage(
                                      resumeId: widget.resumeId,
                                      educationId:
                                          educationList[index].id.toString(),
                                    );
                                  },
                                ),
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
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: width * 0.8,
                                        child: Text(
                                          educationList[index].schoolName!,
                                          style: const TextStyle(
                                            fontSize: 20,
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
                                        Icons.business,
                                        color: Colors.grey,
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
                                        color: Colors.grey,
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
                                  Helper().isNullEmptyOrFalse(
                                          educationList[index].startDate)
                                      ? const SizedBox()
                                      : Row(
                                          children: [
                                            const Icon(
                                              Icons.date_range,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              width: width * 0.8,
                                              child: Helper()
                                                      .isNullEmptyOrFalse(
                                                          educationList[index]
                                                              .endDate)
                                                  ? Text(
                                                      '${Helper().formatMonthYear(educationList[index].startDate ?? '')} - Present',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    )
                                                  : Text(
                                                      '${Helper().formatMonthYear(educationList[index].startDate ?? '')} - ${Helper().formatMonthYear(educationList[index].endDate ?? '')}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                  const SizedBox(height: 10),
                                  Helper().isNullEmptyOrFalse(
                                          educationList[index].description)
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
                                                    .description!,
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
}
