import 'dart:convert';
UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());
class UserModel {
  UserModel({
      bool? success, 
      String? message, 
      String? accessToken, 
      String? refreshToken, 
      User? user,}){
    _success = success;
    _message = message;
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _user = user;
}

  UserModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _accessToken = json['accessToken'];
    _refreshToken = json['refreshToken'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  bool? _success;
  String? _message;
  String? _accessToken;
  String? _refreshToken;
  User? _user;

  bool? get success => _success;
  String? get message => _message;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['accessToken'] = _accessToken;
    map['refreshToken'] = _refreshToken;
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
      String? phone, 
      String? role, 
      String? status, 
      String? membershipNumber, 
      String? profileImage, 
      String? profileImagePublicId, 
      String? joinDate, 
      dynamic paidDate, 
      String? lastLogin, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _email = email;
    _firstName = firstName;
    _lastName = lastName;
    _phone = phone;
    _role = role;
    _status = status;
    _membershipNumber = membershipNumber;
    _profileImage = profileImage;
    _profileImagePublicId = profileImagePublicId;
    _joinDate = joinDate;
    _paidDate = paidDate;
    _lastLogin = lastLogin;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _email = json['email'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _phone = json['phone'];
    _role = json['role'];
    _status = json['status'];
    _membershipNumber = json['membershipNumber'];
    _profileImage = json['profileImage'];
    _profileImagePublicId = json['profileImagePublicId'];
    _joinDate = json['joinDate'];
    _paidDate = json['paidDate'];
    _lastLogin = json['lastLogin'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }
  String? _id;
  String? _email;
  String? _firstName;
  String? _lastName;
  String? _phone;
  String? _role;
  String? _status;
  String? _membershipNumber;
  String? _profileImage;
  String? _profileImagePublicId;
  String? _joinDate;
  dynamic _paidDate;
  String? _lastLogin;
  String? _createdAt;
  String? _updatedAt;

  String? get id => _id;
  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get phone => _phone;
  String? get role => _role;
  String? get status => _status;
  String? get membershipNumber => _membershipNumber;
  String? get profileImage => _profileImage;
  String? get profileImagePublicId => _profileImagePublicId;
  String? get joinDate => _joinDate;
  dynamic get paidDate => _paidDate;
  String? get lastLogin => _lastLogin;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = _email;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['phone'] = _phone;
    map['role'] = _role;
    map['status'] = _status;
    map['membershipNumber'] = _membershipNumber;
    map['profileImage'] = _profileImage;
    map['profileImagePublicId'] = _profileImagePublicId;
    map['joinDate'] = _joinDate;
    map['paidDate'] = _paidDate;
    map['lastLogin'] = _lastLogin;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }

}