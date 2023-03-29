import 'package:cv_builder/pages/contact/ContactPage.dart';
import 'package:cv_builder/pages/education/EducationPage.dart';
import 'package:cv_builder/pages/personal/PersonalPage.dart';
import 'package:cv_builder/pages/reference/Referencepage.dart';
import 'package:cv_builder/pages/skill/SkillPage.dart';
import 'package:cv_builder/pages/work_experience/WorkExperiencePage.dart';
import 'package:flutter/material.dart';

class ResumeDetailsScreen extends StatefulWidget {
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
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.resume);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.resume['name']),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.visibility),
              tooltip: "Preview",
            ),
          ],
        ),
        body: Container(
          child: Column(
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
                  // Tab(
                  //   child: Text(
                  //     "Projects",
                  //     style: TextStyle(fontSize: 16.0),
                  //   ),
                  // ),
                  // Tab(
                  //   child: Text(
                  //     "Cover Letter",
                  //     style: TextStyle(fontSize: 16.0),
                  //   ),
                  // ),
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
                    PersonalPage(resumeId: widget.resume['uuid']),
                    ContactPage(resumeId: widget.resume['uuid']),
                    WorkExperiencePage(resumeId: widget.resume['uuid']),
                    EducationPage(resumeId: widget.resume['uuid']),
                    SkillPage(resumeId: widget.resume['uuid']),
                    ReferencePage(resumeId: widget.resume['uuid']),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
