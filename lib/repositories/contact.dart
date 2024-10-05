import '../apis/api.dart';
import '../providers/user_data_provider.dart';
import '../utils/helper.dart';
import '../utils/urls.dart';

class ContactRepository {
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  Future<Map<String, dynamic>> getContactDetails(String resumeId) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kContactUrl}$resumeId/details/';

      final data = await APIService().sendGetRequest(
        accessToken,
        url,
      );
      return data;
    } catch (error) {
      return Helper().handleApiError(error);
    }
  }

  Future<Map<String, dynamic>> updateContactDetails(
    String contactId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final String accessToken = getAccessToken();
      final String url = '${URLS.kContactUrl}$contactId/update/';

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
}
