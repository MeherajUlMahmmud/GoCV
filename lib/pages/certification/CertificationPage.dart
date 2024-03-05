import 'package:flutter/material.dart';
import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/urls.dart';
import 'package:provider/provider.dart';

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
  late UserProvider userProvider;
  late String accessToken;

  List<dynamic> certificationList = [];

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

    fetchCertifications(widget.resumeId);
  }

  fetchCertifications(String resumeId) {
    String url = '${URLS.kCertificationUrl}$resumeId/list/';
    APIService().sendGetRequest(accessToken, url).then((data) async {
      if (data['status'] == Constants.HTTP_OK) {
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
                  : RefreshIndicator(
                      onRefresh: () async {
                        fetchCertifications(widget.resumeId);
                      },
                      child: ListView.builder(
                        itemCount: certificationList.length,
                        itemBuilder: (context, index) {
                          return Container();
                        },
                      ),
                    ),
    );
  }
}
