import 'package:flutter/material.dart';
import 'package:gocv/apis/user.dart';
import 'package:gocv/screens/profile_screens/UpdateProfileScreen.dart';
import 'package:gocv/screens/utility_screens/ImageViewScreen.dart';
import 'package:gocv/utils/local_storage.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final LocalStorage localStorage = LocalStorage();
  Map<String, dynamic> user = {};
  Map<String, dynamic> tokens = {};

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

    setState(() {
      isLoading = false;
    });
  }

  fetchUserDetails() {
    setState(() {
      isLoading = true;
    });
    UserService()
        .getUserDetails(tokens['access'], user['uuid'])
        .then((data) async {
      print(data);
      if (data['status'] == 200) {
        await localStorage.writeData('user', data['data']);
        setState(() {
          user = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isError = true;
          errorText = data['error'];
        });
      }
    }).catchError((error) {
      setState(() {
        isError = true;
        errorText = error.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, UpdateProfileScreen.routeName)
              .then((value) => {if (value == true) fetchUserDetails()});
        },
        child: const Icon(Icons.edit),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () {
                return Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    fetchUserDetails();
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 10.0),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: ImageFullScreenWrapperWidget(
                        dark: true,
                        child: Image.asset('assets/avatars/rdj.png'),
                        // child: Image.asset(imageFile!.path),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      '${user['applicant']['first_name']} ${user['applicant']['last_name']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.email,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        SizedBox(
                          width: width * 0.8,
                          child: Text(
                            user['email'],
                            style: const TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.phone,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        SizedBox(
                          width: width * 0.8,
                          child: Text(
                            user['applicant']['phone_number'] ?? 'N/A',
                            style: const TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
    );
  }
}
