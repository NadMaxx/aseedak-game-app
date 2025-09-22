import 'dart:convert';
RegisterBody registerBodyFromJson(String str) => RegisterBody.fromJson(json.decode(str));
String registerBodyToJson(RegisterBody data) => json.encode(data.toJson());
class RegisterBody {
  RegisterBody({
      String? fullName, 
      String? email, 
      String? phoneNumber, 
      String? password,}){
    _fullName = fullName;
    _email = email;
    _phoneNumber = phoneNumber;
    _password = password;
}

  RegisterBody.fromJson(dynamic json) {
    _fullName = json['fullName'];
    _email = json['email'];
    _phoneNumber = json['phoneNumber'];
    _password = json['password'];
  }
  String? _fullName;
  String? _email;
  String? _phoneNumber;
  String? _password;

  String? get fullName => _fullName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fullName'] = _fullName;
    map['email'] = _email;
    map['phoneNumber'] = _phoneNumber;
    map['password'] = _password;
    return map;
  }

}