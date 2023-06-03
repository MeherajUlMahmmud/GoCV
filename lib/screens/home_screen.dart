import 'package:gocv/apis/resume.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/screens/main_screens/ResumeDetailsScreen.dart';
import 'package:gocv/screens/profile_screens/ProfileScreen.dart';
import 'package:gocv/screens/utility_screens/SettingsScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/widgets/custom_button.dart';
import 'package:gocv/widgets/profile_tile.dart';
import 'package:gocv/widgets/resume_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

  TextEditingController titleController = TextEditingController();

  late List<dynamic> resumes = [];
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

    fetchResumes(tokens['access'], user['uuid']);
  }

  fetchResumes(String accessToken, String userId) {
    ResumeService()
        .getResumeList(
      accessToken,
      userId,
    )
        .then((data) async {
      if (data['status'] == 200) {
        setState(() {
          resumes = data['data'];
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
      appBar: AppBar(
        title: const Text("GoCV"),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(
        //       Icons.settings,
        //     ),
        //     onPressed: () {
        //       Navigator.pushNamed(context, Settingsscreen.routeName);
        //     },
        //   ),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddDialog(context);
        },
        child: const Icon(
          Icons.add,
          size: 35.0,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
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
                      const SizedBox(width: 10),
                      const Text(
                        'GoCV',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Text(
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
                Navigator.pushNamed(context, Settingsscreen.routeName);
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
                fetchResumes(tokens['access'], user['uuid']);
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
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: resumes.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => showBottomSheet(
                            context,
                            resumes[index],
                            width,
                          ),
                          child: ResumeCard(
                            resume: resumes[index],
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  showBottomSheet(
    BuildContext context,
    Map<String, dynamic> resume,
    double width,
  ) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => SizedBox(
        height: 240.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 30.0,
                    backgroundImage: AssetImage("assets/avatars/rdj.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProfileTile(
                      title: resume['name'],
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  text: 'Update Resume',
                  height: 45,
                  width: width * 0.45,
                  textFontSize: 16,
                  icon: Icons.edit,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResumeDetailsScreen(
                          resume: resume,
                        ),
                      ),
                    );
                  },
                ),
                CustomButton(
                  text: 'Delete Resume',
                  height: 45,
                  width: width * 0.45,
                  textFontSize: 16,
                  icon: Icons.delete,
                  onPressed: () {
                    showDeleteDialog(context, resume);
                  },
                ),
              ],
            ),
          ],
        ),
        // ),
      ),
    );
  }

  showAddDialog(BuildContext context) {
    // set up the button
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget okButton = TextButton(
      child: const Text("Save"),
      onPressed: () async {
        String title = titleController.text;
        titleController.clear();
        createResume(tokens['access'], user['uuid'], title);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Resume title"),
      content: TextFormField(
        autofocus: true,
        controller: titleController,
        decoration: const InputDecoration(
          hintText: "Give a title",
        ),
        keyboardType: TextInputType.text,
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

  void showDeleteDialog(BuildContext context, Map<String, dynamic> resume) {
    // set up the button
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget okButton = TextButton(
      child: const Text("Delete"),
      onPressed: () async {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Deleting " + resume['name']),
      content: const Text("Are you sure about deleting this resume?"),
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
