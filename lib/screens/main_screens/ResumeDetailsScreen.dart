import 'package:gocv/apis/resume.dart';
import 'package:gocv/pages/award/AwardPage.dart';
import 'package:gocv/pages/certification/CertificationPage.dart';
import 'package:gocv/pages/contact/ContactPage.dart';
import 'package:gocv/pages/education/EducationPage.dart';
import 'package:gocv/pages/interest/InterestPage.dart';
import 'package:gocv/pages/language/LanguagePage.dart';
import 'package:gocv/pages/personal/PersonalPage.dart';
import 'package:gocv/pages/reference/Referencepage.dart';
import 'package:gocv/pages/skill/SkillPage.dart';
import 'package:gocv/pages/work_experience/WorkExperiencePage.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/screens/main_screens/ResumePreviewScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:flutter/material.dart';

class ResumeDetailsScreen extends StatefulWidget {
  static const String routeName = "/resume-details";

  final Map<String, dynamic> resume;
  const ResumeDetailsScreen({
    Key? key,
    required this.resume,
  }) : super(key: key);

  @override
  State<ResumeDetailsScreen> createState() => _ResumeDetailsScreenState();
}

class _ResumeDetailsScreenState extends State<ResumeDetailsScreen>
    with SingleTickerProviderStateMixin {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

  late Map<String, dynamic> resumeDetails = {};
  late String personalId = '';
  late String contactId = '';
  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 10, vsync: this);

    readTokensAndUser();
  }

  readTokensAndUser() async {
    tokens = await localStorage.readData('tokens');
    user = await localStorage.readData('user');

    fetchResumeDetails(tokens['access'], widget.resume['uuid']);
  }

  fetchResumeDetails(String accessToken, String resumeId) {
    ResumeService().getResumeDetails(accessToken, resumeId).then((data) async {
      if (data['status'] == 200) {
        setState(() {
          resumeDetails = data['data'];
          personalId = data['data']['personal']['uuid'];
          contactId = data['data']['contact']['uuid'];
          isLoading = false;
          isError = false;
          errorText = '';
        });
      } else {
        if (data['status'] == 401 || data['status'] == 403) {
          Helper().showSnackBar(context, 'Session expired', Colors.red);
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        }
        setState(() {
          isLoading = false;
          isError = true;
          errorText = data['error'];
        });
        Helper().showSnackBar(context, 'Failed to fetch resumes', Colors.red);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.resume['name']),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResumePreviewScreen(
                      resumeId: resumeDetails['uuid'],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.visibility),
              tooltip: "Preview",
            ),
          ],
        ),
        body: Container(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : isError
                  ? Center(
                      child: Text(errorText),
                    )
                  : Column(
                      children: [
                        TabBar(
                          controller: tabController,
                          indicatorColor: Theme.of(context).primaryColor,
                          indicatorWeight: 3.0,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Colors.grey,
                          isScrollable: true,
                          tabs: const [
                            Tab(
                              child: Text(
                                "Personal",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Contact",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Work Experience",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Education",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Skills",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Awards",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Certifications",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Interests",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Languages",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "References",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              PersonalPage(
                                resumeId: widget.resume['uuid'],
                                personalId: personalId,
                              ),
                              ContactPage(
                                resumeId: widget.resume['uuid'],
                                contactId: contactId,
                              ),
                              WorkExperiencePage(
                                  resumeId: widget.resume['uuid']),
                              EducationPage(resumeId: widget.resume['uuid']),
                              SkillPage(resumeId: widget.resume['uuid']),
                              AwardPage(resumeId: widget.resume['uuid']),
                              CertificationPage(
                                  resumeId: widget.resume['uuid']),
                              InterestPage(resumeId: widget.resume['uuid']),
                              LanguagePage(resumeId: widget.resume['uuid']),
                              ReferencePage(resumeId: widget.resume['uuid']),
                            ],
                          ),
                        ),
                      ],
                    ),
        ));
  }
}
