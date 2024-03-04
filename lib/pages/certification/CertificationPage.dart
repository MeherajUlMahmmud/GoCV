import 'package:flutter/material.dart';
import 'package:gocv/apis/api.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/utils/urls.dart';

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
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

  List<dynamic> certificationList = [];

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

    fetchReferences(tokens['access'], widget.resumeId);
  }

  fetchReferences(String accessToken, String resumeId) {
    String url = '${URLS.kCertificationUrl}$resumeId/list/';
    APIService().sendGetRequest(accessToken, url).then((data) async {
      print(data);
      if (data['status'] == 200) {
        setState(() {
          certificationList = data['data']['data'];
          isLoading = false;
          isError = false;
          errorText = '';
        });
      } else {
        if (Helper().isUnauthorizedAccess(data['status'])) {
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
              : certificationList.isEmpty
                  ? const Center(
                      child: Text(
                        'No references added',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    )
                  : Container(),
    );
  }
}
