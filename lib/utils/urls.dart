class URLS {
  // static const String kBaseUrl = "http://192.168.0.108:8000/";
  // static const String kBaseUrl = "http://10.0.2.2:8000/";
  static const String kBaseUrl =
      "http://127.0.0.1:8000/api/"; // for iOS simulator

  // Auth
  static const String kAuthUrl = "${kBaseUrl}auth/";
  static const String kLoginUrl = "${kAuthUrl}login/";
  static const String kRegisterUrl = "${kAuthUrl}register/";
  static const String kRefreshTokenUrl = "${kAuthUrl}refresh/";

  // Resume
  static const String kResumeUrl = "${kBaseUrl}resume/";

  // Personal
  static const String kPersonalUrl = "${kBaseUrl}personal/";

  // Contact
  static const String kContactUrl = "${kBaseUrl}contact/";

  // Experience
  static const String kExperienceUrl = "${kBaseUrl}experience/";
}
