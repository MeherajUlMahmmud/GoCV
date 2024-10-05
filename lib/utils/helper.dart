import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/user_data_provider.dart';
import '../repositories/auth.dart';
import '../screens/auth_screens/login_screen.dart';
import 'constants.dart';
import 'local_storage.dart';

class Helper {
  Map<String, dynamic> handleApiError(dynamic error) {
    if (error is http.ClientException) {
      print('Client error: $error');
      return {
        'status': 400,
        'message': 'Client error occurred: ${error.message}',
      };
    } else if (error is SocketException) {
      print('No internet connection: $error');
      return {
        'status': 503,
        'message': 'No internet connection',
      };
    } else if (error is HttpException) {
      print('HTTP error: $error');
      return {
        'status': 500,
        'message': 'HTTP error occurred: $error',
      };
    } else {
      print('Unexpected error: $error');
      return {
        'status': 500,
        'message': 'Unexpected error occurred: $error',
      };
    }
  }

  static bool checkConnectionError(e) {
    if (e.toString().contains('SocketException') ||
        e.toString().contains('HandshakeException')) {
      return true;
    } else {
      return false;
    }
  }

  bool isUnauthorizedAccess(int status) {
    return status == Constants.httpUnauthorizedCode ||
        status == Constants.httpForbiddenCode;
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

  bool isNullEmptyOrFalse(dynamic value) {
    if (value == null || value == '' || value == false) {
      return true;
    } else {
      return false;
    }
  }

  String formatDateTime(String dateTime) {
    return DateFormat('MMM d, y h:mm a').format(DateTime.parse(dateTime));
  }

  String formatDate(String date) {
    return DateFormat('MMM d, y').format(DateTime.parse(date));
  }

  String formatMonthYear(String date) {
    return DateFormat('MMM y').format(DateTime.parse(date));
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

  void logoutUser(BuildContext context) {
    LocalStorage localStorage = LocalStorage();
    localStorage.clearData();

    Provider.of<UserProvider>(context, listen: false).clearData();

    navigateAndClearStack(context, LoginScreen.routeName);
  }

  void navigateAndClearStack(BuildContext context, String route) {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  void refreshToken(BuildContext context, String refreshToken) {
    LocalStorage localStorage = LocalStorage();
    AuthRepository().refreshToken(refreshToken).then((data) {
      if (data['status'] == Constants.httpOkCode) {
        localStorage.writeData('tokens', {
          'access': data['data']['access'],
          'refresh': refreshToken,
        });
      } else {}
    });
  }
}
