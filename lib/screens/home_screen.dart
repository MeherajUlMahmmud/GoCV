import 'package:gocv/apis/api.dart';
import 'package:gocv/apis/resume.dart';
import 'package:gocv/models/resume.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/screens/main_screens/ResumeDetailsScreen.dart';
import 'package:gocv/screens/profile_screens/ProfileScreen.dart';
import 'package:gocv/screens/utility_screens/SettingsScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/utils/urls.dart';
import 'package:gocv/widgets/resume_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

  TextEditingController titleController = TextEditingController();

  List<Resume> resumes = [];
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

    fetchResumes(tokens['access'], user['id'].toString());
  }

  fetchResumes(String accessToken, String userId) {
    APIService()
        .sendGetRequest(tokens['access'], '${URLS.kResumeUrl}?user=$userId')
        .then((data) async {
      print(data['data']['data']);
      if (data['status'] == 200) {
        setState(() {
          resumes = data['data']['data']
              .map<Resume>((resume) => Resume.fromJson(resume))
              .toList();
          isLoading = false;
          isError = false;
          errorText = '';
        });
      } else {
        if (data['status'] == 401 || data['status'] == 403) {
          Helper().showSnackBar(context, 'Session expired', Colors.red);
          Navigator.pushReplacementNamed(
            context,
            LoginScreen.routeName,
          );
        } else {
          setState(() {
            isLoading = false;
            isError = true;
            errorText = data['error'];
          });
          Helper().showSnackBar(
            context,
            'Failed to fetch resumes',
            Colors.red,
          );
        }
      }
    });
  }

  createResume(String accessToken, String userId, String name) {
    ResumeService().createResume(accessToken, userId, name).then((data) async {
      print(data);
      if (data['status'] == 201) {
        setState(() {
          isLoading = false;
          isError = false;
          errorText = '';
        });
        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
          isError = true;
          errorText = data['error'];
        });
        Helper().showSnackBar(
          context,
          'Failed to create resume',
          Colors.red,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: const Text(
          'GoCV',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              curve: Curves.easeIn,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset(
                      //   'assets/images/logo.png',
                      //   width: 40,
                      //   height: 40,
                      // ),
                      SizedBox(width: 10),
                      Text(
                        'GoCV',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Build Resume on the Go',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, size: 24),
              title: const Text(
                'Home',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_2_outlined, size: 24),
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                // Navigator.pop(context);
                Navigator.pushNamed(context, ProfileScreen.routeName);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.list,
                size: 24,
              ),
              title: const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                // Navigator.pop(context);
                Navigator.pushNamed(context, SettingsScreen.routeName);
              },
            ),
            ListTile(
              leading: const RotationTransition(
                turns: AlwaysStoppedAnimation(180 / 360),
                child: Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text('Would you like to logout?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Logout'),
                          onPressed: () {
                            localStorage
                                .clearData()
                                .then((value) => Navigator.pushNamed(
                                      context,
                                      LoginScreen.routeName,
                                    ));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                fetchResumes(tokens['access'], user['id'].toString());
              },
              child: isError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            errorText,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              fetchResumes(tokens['access'], user['uuid']);
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showAddDialog(context);
                                    },
                                    child: Container(
                                      width: width * 0.45,
                                      padding: const EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.receipt_long),
                                          SizedBox(width: 10),
                                          Text(
                                            'New Resume',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: width * 0.45,
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.receipt_long),
                                        SizedBox(width: 10),
                                        Text(
                                          'Cover Letter',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: width,
                              child: const Text(
                                'My Resumes',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: resumes.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ResumeDetailsScreen(
                                          resume: resumes[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: ResumeCard(
                                    resume: resumes[index],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }

  showAddDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text('Cancel'),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget okButton = TextButton(
      child: const Text('Create'),
      onPressed: () async {
        String title = titleController.text;
        titleController.clear();
        createResume(tokens['access'], user['uuid'], title);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Create a new resume'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resume title',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            autofocus: true,
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Resume title',
            ),
            keyboardType: TextInputType.text,
          ),
        ],
      ),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
