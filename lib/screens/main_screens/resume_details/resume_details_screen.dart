import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gocv/models/resume.dart';
import 'package:gocv/providers/current_resume_provider.dart';
import 'package:gocv/repositories/resume.dart';
import 'package:gocv/screens/main_screens/resume_details/award/award_screen.dart';
import 'package:gocv/screens/main_screens/resume_details/certification/certification_screen.dart';
import 'package:gocv/screens/main_screens/resume_details/contact_screen.dart';
import 'package:gocv/screens/main_screens/resume_details/education/education_screen.dart';
import 'package:gocv/screens/main_screens/resume_details/interest/interest_screen.dart';
import 'package:gocv/screens/main_screens/resume_details/language/language_screen.dart';
import 'package:gocv/screens/main_screens/resume_details/personal_screen.dart';
import 'package:gocv/screens/main_screens/resume_details/reference/reference_screen.dart';
import 'package:gocv/screens/main_screens/resume_details/skill/skill_screen.dart';
import 'package:gocv/screens/main_screens/resume_details/work_experience/work_experience_screen.dart';
import 'package:gocv/screens/main_screens/resume_preview_screen.dart';
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
          if (!mounted) return;
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
      if (!mounted) return;
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
      appBar: AppBar(
        title: Text(
          isLoading
              ? AppLocalizations.of(context)!.loading
              : currentResumeProvider.currentResume.name,
          style: const TextStyle(
            fontSize: 22,
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
              child: const Icon(Icons.visibility),
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
                        tabs: [
                          Tab(
                            child: Text(
                              AppLocalizations.of(context)!.personal,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              AppLocalizations.of(context)!.contact,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              AppLocalizations.of(context)!.work_experience,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              AppLocalizations.of(context)!.education,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              AppLocalizations.of(context)!.skills,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              AppLocalizations.of(context)!.awards,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              AppLocalizations.of(context)!.certifications,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              AppLocalizations.of(context)!.interests,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              AppLocalizations.of(context)!.language,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Tab(
                            child: Text(
                              AppLocalizations.of(context)!.references,
                              style: const TextStyle(fontSize: 16.0),
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
