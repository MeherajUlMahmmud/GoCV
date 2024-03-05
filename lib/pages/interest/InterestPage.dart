import 'package:flutter/material.dart';
import 'package:gocv/apis/api.dart';
import 'package:gocv/pages/interest/AddEditInterestPage.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/urls.dart';
import 'package:provider/provider.dart';

class InterestPage extends StatefulWidget {
  final String resumeId;

  const InterestPage({
    Key? key,
    required this.resumeId,
  }) : super(key: key);

  @override
  State<InterestPage> createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  late UserProvider userProvider;
  late String accessToken;

  List<dynamic> interestList = [];

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  @override
  void initState() {
    super.initState();

    userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    setState(() {
      accessToken = userProvider.tokens['access'].toString();
    });

    fetchInterests(widget.resumeId);
  }

  fetchInterests(String resumeId) {
    final String url = '${URLS.kInterestUrl}$resumeId/list/';

    APIService().sendGetRequest(accessToken, url).then((data) async {
      if (data['status'] == Constants.HTTP_OK) {
        print(data);
        setState(() {
          interestList = data['data']['data'];
          isLoading = false;
          isError = false;
          errorText = '';
        });
      } else {
        if (Helper().isUnauthorizedAccess(data['status'])) {
          Helper().showSnackBar(
            context,
            Constants.SESSION_EXPIRED_MSG,
            Colors.red,
          );
          Helper().logoutUser(context);
        } else {
          print(data['error']);
          setState(() {
            isLoading = false;
            isError = true;
            errorText = data['error'];
          });
          Helper().showSnackBar(
            context,
            'Failed to fetch interests',
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
            MaterialPageRoute(
              builder: (context) {
                return AddEditInterestPage(
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
              : interestList.isEmpty
                  ? const Center(
                      child: Text(
                        'No interests added',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        fetchInterests(widget.resumeId);
                      },
                      child: ListView.builder(
                        itemCount: interestList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _showBottomSheet(
                                context,
                                interestList[index]['uuid'],
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
                                        Icons.interests_outlined,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: width * 0.7,
                                        child: Text(
                                          interestList[index]['interest'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  interestList[index]['description'] == null ||
                                          interestList[index]['description'] ==
                                              ''
                                      ? const SizedBox()
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.description,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 10),
                                              SizedBox(
                                                width: width * 0.7,
                                                child: Text(
                                                  interestList[index]
                                                      ['description'],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ],
                                          ),
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

  void _showBottomSheet(BuildContext context, String interestId) {
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
                    return AddEditInterestPage(
                      resumeId: widget.resumeId,
                      interestId: interestId,
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
                  // _showDeleteConfirmationDialog(context, experienceId);
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
}
