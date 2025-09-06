class SuccessPassModel{
  final String title;
  final String message;
  final String buttonText;
  final String route;
  bool removeRoute;
  SuccessPassModel({
    required this.title,
    required this.message,
    required this.buttonText,
    required this.route,
    this.removeRoute = false,
  });
}