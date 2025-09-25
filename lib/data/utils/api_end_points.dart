

class ApiEndPoints{
  ApiEndPoints._();
  static const String baseUrl = "https://c-reviews.vercel.app/api/";
  static const String socket = "wss://app.thebuilderslodge.org";


  static const String login = "mobile/auth/login";
  static const String logout = "auth/logout";
  static const String forgotPassword = "auth/forgot-password";


  static String signUp = "mobile/auth/register";
  static String resendOTP = "auth/resend-otp";
  static String verifyOTP = "auth/verify-email";


  //game room
  static const String gameRoomCreate = "game-rooms/create";



}