import 'package:gocv/apis/auth.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  static bool checkConnectionError(e) {
    if (e.toString().contains('SocketException') ||
        e.toString().contains('HandshakeException')) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> launchInBrowser(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> copyToClipboard(BuildContext context, String text,
      String successMsg, String errorMsg) async {
    await Clipboard.setData(ClipboardData(text: text))
        .then((value) => showSnackBar(
              context,
              successMsg,
              Colors.green,
            ))
        .catchError((error) => showSnackBar(
              context,
              errorMsg,
              Colors.red,
            ));
  }

  String formatDateTime(String dateTime) {
    return DateFormat('MMM d, y h:mm a').format(DateTime.parse(dateTime));
  }

  String formatDate(String date) {
    return DateFormat('MMM d, y').format(DateTime.parse(date));
  }

  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
      ),
    );
  }

  void navigateAndClearStack(BuildContext context, String route) {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  void refreshToken(BuildContext context, String refreshToken) {
    LocalStorage localStorage = LocalStorage();
    AuthService().refreshToken(refreshToken).then((data) {
      if (data['status'] == 200) {
        localStorage.writeData('tokens', {
          'access': data['data']['access'],
          'refresh': refreshToken,
        });
      } else {}
    });
  }
}
