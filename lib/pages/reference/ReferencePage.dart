import 'package:flutter/material.dart';
import 'package:gocv/apis/api.dart';
import 'package:gocv/pages/reference/AddEditReferencePage.dart';
import 'package:gocv/repositories/reference.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/urls.dart';

class ReferencePage extends StatefulWidget {
  final String resumeId;
  const ReferencePage({
    Key? key,
    required this.resumeId,
  }) : super(key: key);

  @override
  State<ReferencePage> createState() => _ReferencePageState();
}

class _ReferencePageState extends State<ReferencePage> {
  ReferenceRepository referenceRepository = ReferenceRepository();

  List<dynamic> referenceList = [];

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  @override
  void initState() {
    super.initState();

    fetchReferences(widget.resumeId);
  }

  fetchReferences(String resumeId) {
    final String url = '${URLS.kReferenceUrl}$resumeId/list/';

    // APIService().sendGetRequest(accessToken, url).then((data) async {
    //   print(data);
    //   if (data['status'] == Constants.HTTP_OK) {
    //     setState(() {
    //       referenceList = data['data']['data'];
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
    //       print(data['error']);
    //       setState(() {
    //         isLoading = false;
    //         isError = true;
    //         errorText = data['error'];
    //       });
    //       Helper().showSnackBar(
    //         context,
    //         'Failed to fetch references',
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
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddEditReferencePage(
                  resumeId: widget.resumeId,
                );
              },
            ),
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
              : referenceList.isEmpty
                  ? const Center(
                      child: Text(
                        'No references added',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        fetchReferences(widget.resumeId);
                      },
                      child: ListView.builder(
                        itemCount: referenceList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                context,
                                referenceList[index]['id'].toString(),
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
                                        Icons.person,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: width * 0.7,
                                        child: Text(
                                          referenceList[index]['name'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
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
                                          referenceList[index]['position'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
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
                                          referenceList[index]['company_name'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.email_outlined,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: width * 0.7,
                                        child: Text(
                                          referenceList[index]['email'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.phone,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: width * 0.7,
                                        child: Text(
                                          referenceList[index]['phone'],
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

  void _showBottomSheet(BuildContext context, String referenceId) {
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
                    return AddEditReferencePage(
                      resumeId: widget.resumeId,
                      referenceId: referenceId,
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
                  Navigator.of(context).pop(false);

                  _showDeleteConfirmationDialog(context, referenceId);
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

  void _showDeleteConfirmationDialog(BuildContext context, String referenceId) {
    deleteReference() {
      final String url = '${URLS.kReferenceUrl}$referenceId/delete/';

      // APIService().sendDeleteRequest(accessToken, url).then((data) async {
      //   if (data['status'] == Constants.HTTP_OK) {
      //     Navigator.of(context).pop(true);
      //     Helper().showSnackBar(
      //       context,
      //       'Experience deleted successfully',
      //       Colors.green,
      //     );
      //   } else {
      //     if (Helper().isUnauthorizedAccess(data['status'])) {
      //       Helper().showSnackBar(
      //         context,
      //         'Session expired',
      //         Colors.red,
      //       );
      //       Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      //     } else {
      //       print(data['error']);
      //       Helper().showSnackBar(
      //         context,
      //         'Failed to delete experience',
      //         Colors.red,
      //       );
      //     }
      //   }
      // });
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
                deleteReference();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
