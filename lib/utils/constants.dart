class Constants {
  static const String appName = 'GoCV';
  static const String appVersion = '1.0.0';
  static const String appUrl = 'https://flutterchat.com';
  static const String appSupportEmail = '';
  static const String appContactNumber = '+1234567890';

  static const String defultAvatarPath = 'assets/avatars/rdj.png';

  static const String splashScreenRouteName = '/splash-screen';
  static const String loginScreenRouteName = '/login-screen';
  static const String signUpScreenRouteName = '/signup-screen';
  static const String homeScreenRouteName = '/';
  static const String resumePreviewScreenRouteName = '/resume-preview';
  static const String profileScreenRouteName = '/profile-screen';
  static const String updateProfileScreenRouteName = '/update-profile';
  static const String settingsScreenRouteName = '/settings';
  static const String accountSettingsScreenRouteName = '/account-settings';
  static const String emailUpdateScreenRouteName = '/email-update';
  static const String notFoundScreenRouteName = '/not-found';

  static const int httpOkCode = 200;
  static const int httpCreatedCode = 201;
  static const int httpNoContentCode = 204;
  static const int httpBadRequestCode = 400;
  static const int httpUnauthorizedCode = 401;
  static const int httpForbiddenCode = 403;
  static const int httpNotFoundCode = 404;
  static const int httpInternalServerErrorCode = 500;

  static const String dataUpdatedMsg = 'Data updated successfully';
  static const String sessionExpiredMsg = 'Session expired, please login again';
  static const String genericErrorMsg =
      'Unable to process your request, please try again later';
}
