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
import 'package:gocv/repositories/resume.dart';
import 'package:gocv/screens/main_screens/ResumePreviewScreen.dart';
import 'package:flutter/material.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
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
  ResumeRepository resumeRepository = ResumeRepository();

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

    currentResumeProvider = Provider.of<CurrentResumeProvider>(
      context,
      listen: false,
    );

    setState(() {
      resumeId = currentResumeProvider.currentResume.id.toString();
    });

    fetchResumeDetails();
  }

  fetchResumeDetails() async {
    try {
      final response = await resumeRepository.getResumeDetails(resumeId);
      print(response);

      if (response['status'] == Constants.httpOkCode) {
        final Resume fetchedResume = Resume.fromJson(response['data']['data']);
        currentResumeProvider.setCurrentResume(fetchedResume);

        setState(() {
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
          Helper().showSnackBar(
            context,
            Constants.genericErrorMsg,
            Colors.red,
          );
        }
      }
    } catch (error) {
      print(error);
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error fetching resume details: $error';
      });
      Helper().showSnackBar(
        context,
        'Error fetching resume details',
        Colors.red,
      );
    }
  }

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
