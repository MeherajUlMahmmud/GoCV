import 'package:flutter/material.dart';
import 'package:gocv/apis/api.dart';
import 'package:gocv/models/applicant.dart';
import 'package:gocv/screens/profile_screens/UpdateProfileScreen.dart';
import 'package:gocv/screens/utility_screens/ImageViewScreen.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:gocv/utils/urls.dart';

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

  Applicant applicant = Applicant();

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

    fetchUserDetails(tokens['access']);
  }

  fetchUserDetails(String accessToken) {
    setState(() {
      isLoading = true;
    });
    String url = '${URLS.kUserUrl}profile/';
    APIService().sendGetRequest(accessToken, url).then((data) async {
      print(data['data']);
      if (data['status'] == 200) {
        await localStorage.writeData('user', data['data']['user_data']);
        setState(() {
          applicant = Applicant.fromJson(data['data']['applicant_data']);

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(12.0),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, UpdateProfileScreen.routeName).then(
              (value) =>
                  {if (value == true) fetchUserDetails(tokens['access'])});
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
                    fetchUserDetails(tokens['access']);
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
                      '${applicant.firstName!} ${applicant.lastName!}',
                      style: const TextStyle(
                        fontSize: 22,
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
                            applicant.phoneNumber ?? 'N/A',
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
