import 'package:cv_builder/apis/resume.dart';
import 'package:cv_builder/screens/auth_screens/LoginScreen.dart';
import 'package:cv_builder/screens/main_screens/ResumeDetailsScreen.dart';
import 'package:cv_builder/screens/utility_screens/SettingsScreen.dart';
import 'package:cv_builder/utils/helper.dart';
import 'package:cv_builder/utils/local_storage.dart';
import 'package:cv_builder/widgets/profile_tile.dart';
import 'package:cv_builder/widgets/resume_card.dart';
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
        if (data['status'] == 401) {
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
        Helper().showSnackBar(context, 'Failed to create resume', Colors.red);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GoCV"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.pushNamed(context, Settingsscreen.routeName);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddDialog(context);
        },
        child: Icon(
          Icons.add,
          size: 35.0,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              fetchResumes(tokens['access'], user['uuid']);
                            },
                            child: Text("Retry"),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: resumes.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => showBottomSheet(context, resumes[index]),
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
  ) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20.0),
          topRight: const Radius.circular(20.0),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => Container(
        height: 200.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
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
            // Divider(color: Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 45.0,
                  child: ElevatedButton(
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
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 25),
                        SizedBox(width: 10.0),
                        Text(
                          "Update Resume",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 45.0,
                  child: ElevatedButton(
                    onPressed: () {
                      showDeleteDialog(context, resume);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 25),
                        SizedBox(width: 10.0),
                        Text(
                          "Delete Resume",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
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
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget okButton = TextButton(
      child: Text("Save"),
      onPressed: () async {
        String title = titleController.text;
        titleController.clear();
        createResume(tokens['access'], user['uuid'], title);
        // Person newPerson = Person(
        //   title: title,
        //   creationDateTime: DateFormat.yMd().add_jm().format(DateTime.now()),
        // );

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         NewPerson(isEditing: false, person: newPerson),
        //   ),
        // ).then((value) {
        //   setState(() {});
        // });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Resume title"),
      content: TextFormField(
        autofocus: true,
        controller: titleController,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
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
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget okButton = TextButton(
      child: Text("Delete"),
      onPressed: () async {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Deleting " + resume['name']),
      content: Text("Are you sure about deleting this resume?"),
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
