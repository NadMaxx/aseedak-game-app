import 'dart:convert';
UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());
class UserModel {
  UserModel({
      String? message, 
      String? token, 
      User? user,}){
    _message = message;
    _token = token;
    _user = user;
}

  UserModel.fromJson(dynamic json) {
    _message = json['message'];
    _token = json['token'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? _message;
  String? _token;
  User? _user;

  String? get message => _message;
  String? get token => _token;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['token'] = _token;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }

}

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      String? id, 
      String? email, 
      String? firstName, 
      String? lastName, 
      String? username, 
      String? phoneNumber,
      String? avatar,
      String? role, 
      bool? isActive, 
      bool? emailVerified, 
      int? gamesPlayed, 
      int? gamesWon, 
      int? totalKills,}){
    _id = id;
    _email = email;
    _firstName = firstName;
    _lastName = lastName;
    _phoneNumber = phoneNumber;
    _username = username;
    _avatar = avatar;
    _role = role;
    _isActive = isActive;
    _emailVerified = emailVerified;
    _gamesPlayed = gamesPlayed;
    _gamesWon = gamesWon;
    _totalKills = totalKills;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _email = json['email'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _username = json['username'];
    _avatar = json['avatar'];
    _role = json['role'];
    _isActive = json['isActive'];
    _phoneNumber = json['phoneNumber'];
    _emailVerified = json['emailVerified'];
    _gamesPlayed = json['gamesPlayed'];
    _gamesWon = json['gamesWon'];
    _totalKills = json['totalKills'];
  }
  String? _id;
  String? _email;
  String? _phoneNumber;
  String? _firstName;
  String? _lastName;
  String? _username;
  String? _avatar;
  String? _role;
  bool? _isActive;
  bool? _emailVerified;
  int? _gamesPlayed;
  int? _gamesWon;
  int? _totalKills;

  String? get id => _id;
  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get username => _username;
  String? get avatar => _avatar;
  String? get role => _role;
  String? get phoneNumber => _phoneNumber;
  bool? get isActive => _isActive;
  bool? get emailVerified => _emailVerified;
  int? get gamesPlayed => _gamesPlayed;
  int? get gamesWon => _gamesWon;
  int? get totalKills => _totalKills;

  set email(String? value) {
    _email = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = _email;
    map['phoneNumber'] = _phoneNumber;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['username'] = _username;
    map['avatar'] = _avatar;
    map['role'] = _role;
    map['isActive'] = _isActive;
    map['emailVerified'] = _emailVerified;
    map['gamesPlayed'] = _gamesPlayed;
    map['gamesWon'] = _gamesWon;
    map['totalKills'] = _totalKills;
    return map;
  }

  set phoneNumber(String? value) {
    _phoneNumber = value;
  }

  set firstName(String? value) {
    _firstName = value;
  }

  set lastName(String? value) {
    _lastName = value;
  }

  set username(String? value) {
    _username = value;
  }

  set avatar(String? value) {
    _avatar = value;
  }

  set role(String? value) {
    _role = value;
  }

  set isActive(bool? value) {
    _isActive = value;
  }

  set emailVerified(bool? value) {
    _emailVerified = value;
  }

  set gamesWon(int? value) {
    _gamesWon = value;
  }

  set totalKills(int? value) {
    _totalKills = value;
  }

}