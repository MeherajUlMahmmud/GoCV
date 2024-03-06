import 'package:gocv/apis/api.dart';
import 'package:gocv/models/contact.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/utils/urls.dart';

class ContactRepository {
  // Method to get the access token from UserProvider
  String getAccessToken() {
    return UserProvider().tokens['access'];
  }

  Map<String, dynamic> getContactDetails(String resumeId) {
    final String accessToken = getAccessToken();
    final String url = '${URLS.kContactUrl}$resumeId/details/';

    Contact contact = Contact();

    APIService().sendGetRequest(accessToken, url).then((data) async {
      print(data);
      contact = Contact.fromJson(data['data']);
      return {
        'status': data['status'] ?? 500,
        'message': data['message'] ?? '',
        'data': contact,
      };
    }).catchError((error) {
      return {
        'status': 500,
        'message': 'Internal Server Error',
        'data': contact,
      };
    });

    return {
      'status': 500,
      'message': 'Internal Server Error',
      'data': contact,
    };
  }

  Map<String, dynamic> updateContactDetails(
    String contactId,
    Map<String, dynamic> contactData,
  ) {
    final String accessToken = getAccessToken();
    final String url = '${URLS.kContactUrl}$contactId/update/';

    Contact contact = Contact();

    APIService()
        .sendPatchRequest(accessToken, contactData, url)
        .then((data) async {
      print(data);
      return {
        'status': data['status'] ?? 500,
        'message': data['message'] ?? '',
        'data': contact,
      };
    }).catchError((error) {
      return {
        'status': 500,
        'message': 'Internal Server Error',
        'data': contact,
      };
    });

    return {
      'status': 500,
      'message': 'Internal Server Error',
      'data': contact,
    };
  }
}
