import 'dart:io';

import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/user_data_provider.dart';
import 'package:gocv/utils/urls.dart';

class PersonalRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  getPersonalDetails(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kPersonalUrl}$resumeId/details/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting personal details: $error');
      return {
        'status': 500,
        'message': 'Error getting personal details: $error',
      };
    }
  }

  updatePersonalDetails(
    String personalId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kPersonalUrl}$personalId/update/';

      final data =
          await APIService().sendPatchRequest(accessToken, updatedData, url);
      return data;
    } catch (error) {
      print('Error updating personal details: $error');
      return {
        'status': 500,
        'message': 'Error updating personal details: $error',
      };
    }
  }

  updatePersonalImage(String personalId, File imagePath) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kPersonalUrl}$personalId/update-image/';

      final data = await APIService().sendPatchRequest(
        accessToken,
        {
          'resume_picture': imagePath,
        },
        url,
        isMultipart: true,
      );
      return data;
    } catch (error) {
      print('Error updating personal image: $error');
      return {
        'status': 500,
        'message': 'Error updating personal image: $error',
      };
    }
  }
}
