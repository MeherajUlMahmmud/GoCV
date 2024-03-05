import 'package:flutter/material.dart';
import 'package:gocv/apis/api.dart';
import 'package:gocv/models/applicant.dart';
import 'package:gocv/models/user.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/providers/UserProfileProvider.dart';
import 'package:gocv/screens/profile_screens/UpdateProfileScreen.dart';
import 'package:gocv/screens/utility_screens/ImageViewScreen.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/urls.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProvider userProvider = UserProvider();
  late String userId;

  late UserProfileProvider userProfileProvider;

  bool isLoading = true;
  bool isError = false;
  String errorText = '';

  @override
  void initState() {
    super.initState();

    userProfileProvider = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );

    setState(() {
      accessToken = userProvider.tokens['access'].toString();
      userId = userProvider.userData!.id.toString();
    });
    fetchUserProfile();
  }

  fetchUserProfile() {
    setState(() {
      isLoading = true;
    });
    const String url = '${URLS.kUserUrl}profile/';

    APIService().sendGetRequest(accessToken, url).then((data) async {
      if (data['status'] == Constants.HTTP_OK) {
        final UserBase userBase = UserBase.fromJson(data['data']['user_data']);
        final Applicant applicant =
            Applicant.fromJson(data['data']['applicant_data']);
        final UserProfile userProfile = UserProfile(
          userData: userBase,
          applicantData: applicant,
        );
        userProfileProvider.setUserProfile(userProfile);
        // await localStorage.writeData('user', data['data']['user_data']);
        setState(() {
          isLoading = false;
        });
      } else {
        if (Helper().isUnauthorizedAccess(data['status'])) {
          Helper().showSnackBar(
            context,
            Constants.SESSION_EXPIRED_MSG,
            Colors.red,
          );
          Helper().logoutUser(context);
        } else {
          setState(() {
            isError = true;
            errorText = data['error'];
          });
        }
      }
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, UpdateProfileScreen.routeName)
              .then((value) => {if (value == true) fetchUserProfile()});
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
                    fetchUserProfile();
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
                      '${userProfileProvider.userProfile.applicantData?.firstName} ${userProfileProvider.userProfile.applicantData?.lastName}',
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.email,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          userProvider.userData!.email ?? 'N/A',
                          style: const TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.phone,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          userProfileProvider
                                  .userProfile.applicantData?.phoneNumber ??
                              'N/A',
                          style: const TextStyle(fontSize: 18),
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
