import 'package:gocv/apis/api.dart';
import 'package:gocv/models/resume.dart';
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
import 'package:gocv/providers/CurrentResumeProvider.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/screens/main_screens/ResumePreviewScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:gocv/utils/urls.dart';
import 'package:provider/provider.dart';

class ResumeDetailsScreen extends StatefulWidget {
  static const String routeName = '/resume-details';

  const ResumeDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ResumeDetailsScreen> createState() => _ResumeDetailsScreenState();
}

class _ResumeDetailsScreenState extends State<ResumeDetailsScreen>
    with SingleTickerProviderStateMixin {
  late UserProvider userProvider;
  late String accessToken;
  late String userId;

  late CurrentResumeProvider currentResumeProvider;
  late String resumeId;

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 10, vsync: this);

    userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    currentResumeProvider = Provider.of<CurrentResumeProvider>(
      context,
      listen: false,
    );

    setState(() {
      accessToken = userProvider.tokens['access'].toString();
      userId = userProvider.userData!.id.toString();

      resumeId = currentResumeProvider.currentResume.id.toString();
    });

    fetchResumeDetails();
  }

  fetchResumeDetails() {
    APIService()
        .sendGetRequest(accessToken, '${URLS.kResumeUrl}$resumeId/details/')
        .then((data) async {
      print(data['data']['contact']);
      if (data['status'] == 200) {
        print(data['data']);
        currentResumeProvider
            .setCurrentResume(Resume.fromJson(data['data']['data']));

        setState(() {
          isLoading = false;
          isError = false;
          errorText = '';
        });
      } else {
        if (Helper().isUnauthorizedAccess(data['status'])) {
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

  // fetchPersonalDetails
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isLoading ? 'Loading...' : currentResumeProvider.currentResume.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(left: 10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 5.0),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ResumePreviewScreen.routeName);
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Icon(Icons.visibility, color: Colors.black),
            ),
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
                              'Personal',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Contact',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Work Experience',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Education',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Skills',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Awards',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Certifications',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Interests',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Languages',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'References',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            PersonalPage(resumeId: resumeId),
                            ContactPage(resumeId: resumeId),
                            WorkExperiencePage(resumeId: resumeId),
                            EducationPage(resumeId: resumeId),
                            SkillPage(resumeId: resumeId),
                            AwardPage(resumeId: resumeId),
                            CertificationPage(resumeId: resumeId),
                            InterestPage(resumeId: resumeId),
                            LanguagePage(resumeId: resumeId),
                            ReferencePage(resumeId: resumeId),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
