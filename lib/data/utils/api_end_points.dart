

class ApiEndPoints{
  ApiEndPoints._();
  static const String baseUrl = "https://c-reviews.vercel.app/api/mobile/";
  static const String socket = "wss://app.thebuilderslodge.org";


  static const String login = "auth/login";
  static const String logout = "auth/logout";
  static const String trestle = "admin/calendar";
  static const String support = "admin/support";
  static const String phone = "admin/phonebook";
  static const String documents = "admin/documents";
  static const String getChatThread = "admin/chat/rooms";
  static const String sendMessage = "admin/chat";
  static const String festiveBoard = "admin/festive-board";
  static const String calendar = "calendar";
  static const String notifications = "admin/notifications";
  static const String categories = "/admin/meal/categories";
  static const String createChat = "admin/chat/rooms";

  static String forgotPassword = "auth/forgot-password";



}