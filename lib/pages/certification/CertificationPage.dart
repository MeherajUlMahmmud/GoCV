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
        setState(() {
          certificationList = response['data'].map<Certificate>((award) {
            return Certificate.fromJson(award);
          }).toList();
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
            Constants.genericErrorMsg,
            Colors.red,
          );
        }
      }
    } catch (error) {
      print('Error fetching certifications: $error');
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error fetching certifications: $error';
      });
    }
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
