import 'package:gocv/apis/api.dart';
import 'package:gocv/providers/user_data_provider.dart';
import 'package:gocv/utils/urls.dart';

class ContactRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  Future<Map<String, dynamic>> getContactDetails(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kContactUrl}$resumeId/details/';

      final data = await APIService().sendGetRequest(accessToken, url);
      return data;
    } catch (error) {
      print('Error getting contact details: $error');
      return {
        'status': 500,
        'message': 'Error getting contact details: $error',
      };
    }
  }

  Future<Map<String, dynamic>> updateContactDetails(
    String contactId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kContactUrl}$contactId/update/';

      final data =
          await APIService().sendPatchRequest(accessToken, updatedData, url);
      return data;
    } catch (error) {
      print('Error updating contact details: $error');
      return {
        'status': 500,
        'message': 'Error updating contact details: $error',
      };
    }
  }
}
