class AppServices {
  static String getBaseUrl() {
    return 'http://192.168.56.1:21079';
  }

  static String getLoginEndpoint() {
    return '${getBaseUrl()}/login';
  }

  static String getRegistEndpoint() {
    return '${getBaseUrl()}/register';
  }

  static String getAuthEndpoint() {
    return '${getBaseUrl()}/auth';
  }

  static String getDetectEndpoint() {
    return '${getBaseUrl()}/detect';
  }

  static String getFreeSlotEndpoint() {
    return '${getBaseUrl()}/free_slots';
  }

  static String getUserEndpoint() {
    return '${getBaseUrl()}/get_user';
  }

  static String getAnalyticEndPoint() {
    return '${getBaseUrl()}/api/statistik';
  }

  static String getForgotPassEndPoint() {
    return '${getBaseUrl()}/forgot_password';
  }
}
