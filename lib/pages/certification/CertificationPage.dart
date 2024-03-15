import 'package:flutter/material.dart';
import 'package:gocv/models/certificate.dart';
import 'package:gocv/repositories/certificate.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';

class CertificationPage extends StatefulWidget {
  final String resumeId;

  const CertificationPage({
    Key? key,
    required this.resumeId,
  }) : super(key: key);

  @override
  State<CertificationPage> createState() => _CertificationPageState();
}

class _CertificationPageState extends State<CertificationPage> {
  CertificateRepository certificateRepository = CertificateRepository();

  List<Certificate> certificationList = [];

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  @override
  void initState() {
    super.initState();

    fetchCertifications(widget.resumeId);
  }

  fetchCertifications(String resumeId) async {
    Map<String, dynamic> params = {
      'resume_id': resumeId,
    };
    try {
      final response = await certificateRepository.getCertificates(
        widget.resumeId,
        params,
      );

      if (response['status'] == Constants.httpOkCode) {
        final List<Certificate> fetchedCertificateList =
            (response['data']['data'] as List).map<Certificate>((award) {
          return Certificate.fromJson(award);
        }).toList();

        setState(() {
          certificationList = fetchedCertificateList;
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
      if (!mounted) return;
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error fetching skill list: $error';
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) {
          //       return Container();
          //     },
          //   ),
          // );
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
              : certificationList.isEmpty
                  ? const Center(
                      child: Text(
                        'No certificates added',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        fetchCertifications(widget.resumeId);
                      },
                      child: ListView.builder(
                        itemCount: certificationList.length,
                        itemBuilder: (context, index) {
                          return CertificateItem(
                            widget: widget,
                            certificationList: certificationList,
                            index: index,
                            width: width,
                            onDelete: () {
                              // deleteEducation(
                              //   educationList[index].id.toString(),
                              // );
                            },
                          );
                        },
                      ),
                    ),
    );
  }
}

class CertificateItem extends StatelessWidget {
  const CertificateItem({
    super.key,
    required this.widget,
    required this.certificationList,
    required this.index,
    required this.width,
    required this.onDelete,
  });

  final CertificationPage widget;
  final List<Certificate> certificationList;
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
          color: certificationList[index].isActive!
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
                  Icons.business,
                  color: Colors.grey,
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: width * 0.7,
                  child: Text(
                    certificationList[index].title ?? '',
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return AddEditEducationPage(
                          //         resumeId: widget.resumeId,
                          //         educationId:
                          //             educationList[index].id.toString(),
                          //       );
                          //     },
                          //   ),
                          // );
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
                ),
              ],
            ),
            const SizedBox(height: 10),
            Helper().isNullEmptyOrFalse(certificationList[index].startDate)
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
                        child: Helper().isNullEmptyOrFalse(
                                certificationList[index].endDate)
                            ? Text(
                                '${Helper().formatMonthYear(certificationList[index].startDate!)} - Present',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            : Text(
                                '${Helper().formatMonthYear(certificationList[index].startDate!)} - ${Helper().formatMonthYear(certificationList[index].endDate ?? '')}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ],
                  ),
            const SizedBox(height: 10),
            Helper().isNullEmptyOrFalse(certificationList[index].description)
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
                          certificationList[index].description!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ));
  }
}
