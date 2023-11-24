import 'package:flutter/material.dart';
import 'package:gocv/apis/api.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/utils/urls.dart';

class AwardPage extends StatefulWidget {
  final String resumeId;

  const AwardPage({
    Key? key,
    required this.resumeId,
  }) : super(key: key);

  @override
  State<AwardPage> createState() => _AwardPageState();
}

class _AwardPageState extends State<AwardPage> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

  List<dynamic> awardList = [];

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

    fetchAwards(tokens['access'], widget.resumeId);
  }

  fetchAwards(String accessToken, String resumeId) {
    String url = '${URLS.kAwardUrl}$resumeId/';
    APIService().sendGetRequest(accessToken, url).then((data) async {
      print(data);
      if (data['status'] == 200) {
        setState(() {
          awardList = data['data']['data'];
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
            'Failed to fetch references',
            Colors.red,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Container();
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
              : awardList.isEmpty
                  ? const Center(
                      child: Text(
                        'No awards added',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        fetchAwards(tokens['access'], widget.resumeId);
                      },
                      child: ListView.builder(
                        itemCount: awardList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // _showBottomSheet(
                              //   context,
                              //   awardList[index]['id'].toString(),
                              // );
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
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
