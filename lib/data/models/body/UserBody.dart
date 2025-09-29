import 'dart:convert';
UserBody userBodyFromJson(String str) => UserBody.fromJson(json.decode(str));
String userBodyToJson(UserBody data) => json.encode(data.toJson());
class UserBody {
  UserBody({
      String? firstName, 
      String? lastName, 
      String? username, 
      String? email, 
      String? phoneNumber, 
      String? avatar,}){
    _firstName = firstName;
    _lastName = lastName;
    _username = username;
    _email = email;
    _phoneNumber = phoneNumber;
    _avatar = avatar;
}

  UserBody.fromJson(dynamic json) {
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _username = json['username'];
    _email = json['email'];
    _phoneNumber = json['phoneNumber'];
    _avatar = json['avatar'];
  }
  String? _firstName;
  String? _lastName;
  String? _username;
  String? _email;
  String? _phoneNumber;
  String? _avatar;

  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get username => _username;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get avatar => _avatar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['username'] = _username;
    map['email'] = _email;
    map['phoneNumber'] = _phoneNumber;
    map['avatar'] = _avatar;
    return map;
  }

}