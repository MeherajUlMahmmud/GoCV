import 'package:flutter/material.dart';
import 'package:gocv/models/interest.dart';
import 'package:gocv/repositories/interest.dart';
import 'package:gocv/screens/main_screens/resume_details/interest/add_edit_interest_screen.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';

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
  InterestRepository interestRepository = InterestRepository();

  List<Interest> interestList = [];

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  @override
  void initState() {
    super.initState();

    fetchInterests(widget.resumeId);
  }

  fetchInterests(String resumeId) async {
    Map<String, dynamic> params = {
      'resume_id': resumeId,
    };

    try {
      final response = await interestRepository.getInterests(
        widget.resumeId,
        params,
      );

      if (response['status'] == Constants.httpOkCode) {
        final List<Interest> fetchedInterestist =
            (response['data']['data'] as List).map<Interest>((award) {
          return Interest.fromJson(award);
        }).toList();

        setState(() {
          interestList = fetchedInterestist;
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
        errorText = 'Error fetching skill list: $error';
      });
      Helper().showSnackBar(
        context,
        Constants.genericErrorMsg,
        Colors.red,
      );
    }
  }

  deleteInterest(String interestId) async {
    try {
      final response = await interestRepository.deleteInterest(
        widget.resumeId,
        interestId,
      );

      if (response['status'] == Constants.httpOkCode) {
        setState(() {
          interestList.removeWhere(
            (element) => element.id.toString() == interestId,
          );
          isError = false;
        });

        if (!mounted) return;
        Helper().showSnackBar(
          context,
          response['message'],
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
          if (!mounted) return;
          Helper().showSnackBar(
            context,
            response['message'],
            Colors.red,
          );
        }
      }
    } catch (error) {
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
                          return interestItem(width, index);
                        },
                      ),
                    ),
    );
  }

  Widget interestItem(double width, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            offset: Offset(0, 3),
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
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: width * 0.7,
                child: Text(
                  interestList[index].name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddEditInterestPage(
                              resumeId: widget.resumeId,
                              interestId: interestList[index].id.toString(),
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
                            title: const Text('Delete Interest'),
                            content: const Text(
                              'Are you sure you want to delete this interest?',
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
                                  // await deleteLanguage(
                                  //   languageList[index].id.toString(),
                                  // );
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
                ],
              ),
            ],
          ),
          interestList[index].description == null
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.description,
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: width * 0.7,
                        child: Text(
                          interestList[index].description ?? '',
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
    );
  }
}
