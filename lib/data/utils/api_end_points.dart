

class ApiEndPoints{
  ApiEndPoints._();
  static const String baseUrl = "https://c-reviews.vercel.app/api/";
  static const String socket = "wss://app.thebuilderslodge.org";


  static const String login = "mobile/auth/login";
  static const String logout = "auth/logout";
  static const String forgotPassword = "/mobile/auth/forgot-password";
  static const String changePassword = "auth/change-password";


  static String signUp = "mobile/auth/register";
  static String resendOTP = "auth/resend-otp";
  static String verifyOTP = "auth/verify-email";
  static String me = "user/profile";


  //game room
  static const String gameRoomCreate = "game-rooms/create";
  static const String joinRoom = "game-rooms/";

  //purchase
  static const String updateMaxPlayers = "mobile/purchases/update-max-members";
  static const String getAvatars = "mobile/characters";
  static const String getDecks = "admin/word-decks";
  static const String getUserDecks = "user/word-decks";
  static const String updateUser = "user/update";



}