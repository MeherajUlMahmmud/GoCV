import 'dart:io';

import '../apis/api.dart';
import '../providers/user_data_provider.dart';
import '../utils/helper.dart';
import '../utils/urls.dart';

class PersonalRepository {
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
      return Helper().handleApiError(error);
    }
  }

  updatePersonalDetails(
    String personalId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kPersonalUrl}$personalId/update/';

      final data = await APIService().sendPatchRequest(
        accessToken,
        updatedData,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }

  updatePersonalImage(String personalId, File imagePath) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kPersonalUrl}$personalId/update-image/';

      final data = await APIService().sendPatchRequest(
        accessToken,
        {'resume_picture': imagePath},
        url,
        isMultipart: true,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }
}
