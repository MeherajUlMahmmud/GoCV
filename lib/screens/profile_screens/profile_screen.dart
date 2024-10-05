import 'package:flutter/material.dart';
import 'package:gocv/models/applicant.dart';
import 'package:gocv/models/user.dart';
import 'package:gocv/providers/user_data_provider.dart';
import 'package:gocv/providers/user_profile_provider.dart';
import 'package:gocv/repositories/user.dart';
import 'package:gocv/screens/profile_screens/update_profile_screen.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = Constants.profileScreenRouteName;

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserRepository userRepository = UserRepository();
  UserProvider userProvider = UserProvider();

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

    fetchUserProfile();
  }

  fetchUserProfile() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await userRepository.getUserProfile();

      if (response['status'] == Constants.httpOkCode) {
        final UserBase userBase =
            UserBase.fromJson(response['data']['user_data']);
        final Applicant applicant =
            Applicant.fromJson(response['data']['applicant_data']);
        final UserProfile userProfile = UserProfile(
          userData: userBase,
          applicantData: applicant,
        );
        userProfileProvider.setUserProfile(userProfile);
        setState(() {
          isLoading = false;
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
            isError = true;
            errorText = response['error'];
          });
        }
      }
    } catch (error) {
      print('Error getting user profile: $error');
      if (!mounted) return;
      setState(() {
        isLoading = false;
        isError = true;
        errorText = 'Error getting user profile: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: userProfileProvider.userProfile.applicantData
                                    ?.profilePicture !=
                                null
                            ? Image.network(
                                userProfileProvider
                                    .userProfile.applicantData!.profilePicture!,
                                height: 200.0,
                              )
                            : Image.asset(
                                Constants.defaultAvatarPath,
                                height: 200.0,
                              ),
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
                        Expanded(
                          child: Text(
                            userProvider.userData!.email ?? 'N/A',
                            style: const TextStyle(fontSize: 18),
                          ),
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
                        Expanded(
                          child: Text(
                            userProfileProvider
                                    .userProfile.applicantData?.phoneNumber ??
                                'N/A',
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
