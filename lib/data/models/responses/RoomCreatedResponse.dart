import 'dart:convert';
RoomCreatedResponse roomCreatedResponseFromJson(String str) => RoomCreatedResponse.fromJson(json.decode(str));
String roomCreatedResponseToJson(RoomCreatedResponse data) => json.encode(data.toJson());
class RoomCreatedResponse {
  RoomCreatedResponse({
      String? message, 
      Room? room, 
      int? emailsSent,}){
    _message = message;
    _room = room;
    _emailsSent = emailsSent;
}

  RoomCreatedResponse.fromJson(dynamic json) {
    _message = json['message'];
    _room = json['room'] != null ? Room.fromJson(json['room']) : null;
    _emailsSent = json['emailsSent'];
  }
  String? _message;
  Room? _room;
  int? _emailsSent;

  String? get message => _message;
  Room? get room => _room;
  int? get emailsSent => _emailsSent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    if (_room != null) {
      map['room'] = _room?.toJson();
    }
    map['emailsSent'] = _emailsSent;
    return map;
  }

}

Room roomFromJson(String str) => Room.fromJson(json.decode(str));
String roomToJson(Room data) => json.encode(data.toJson());
class Room {
  Room({
      String? id, 
      String? name, 
      String? code, 
      int? maxPlayers, 
      String? status, 
      String? createdBy, 
      List<String>? wordSet, 
      int? currentRound, 
      int? timeLimit, 
      String? createdAt, 
      String? updatedAt, 
      dynamic startedAt, 
      dynamic finishedAt, 
      List<Players>? players, 
      Creator? creator,}){
    _id = id;
    _name = name;
    _code = code;
    _maxPlayers = maxPlayers;
    _status = status;
    _createdBy = createdBy;
    _wordSet = wordSet;
    _currentRound = currentRound;
    _timeLimit = timeLimit;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _startedAt = startedAt;
    _finishedAt = finishedAt;
    _players = players;
    _creator = creator;
}

  Room.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _maxPlayers = json['maxPlayers'];
    _status = json['status'];
    _createdBy = json['createdBy'];
    _wordSet = json['wordSet'] != null ? json['wordSet'].cast<String>() : [];
    _currentRound = json['currentRound'];
    _timeLimit = json['timeLimit'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _startedAt = json['startedAt'];
    _finishedAt = json['finishedAt'];
    if (json['players'] != null) {
      _players = [];
      json['players'].forEach((v) {
        _players?.add(Players.fromJson(v));
      });
    }
    _creator = json['creator'] != null ? Creator.fromJson(json['creator']) : null;
  }
  String? _id;
  String? _name;
  String? _code;
  int? _maxPlayers;
  String? _status;
  String? _createdBy;
  List<String>? _wordSet;
  int? _currentRound;
  int? _timeLimit;
  String? _createdAt;
  String? _updatedAt;
  dynamic _startedAt;
  dynamic _finishedAt;
  List<Players>? _players;
  Creator? _creator;

  String? get id => _id;
  String? get name => _name;
  String? get code => _code;
  int? get maxPlayers => _maxPlayers;
  String? get status => _status;
  String? get createdBy => _createdBy;
  List<String>? get wordSet => _wordSet;
  int? get currentRound => _currentRound;
  int? get timeLimit => _timeLimit;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get startedAt => _startedAt;
  dynamic get finishedAt => _finishedAt;
  List<Players>? get players => _players;
  Creator? get creator => _creator;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['maxPlayers'] = _maxPlayers;
    map['status'] = _status;
    map['createdBy'] = _createdBy;
    map['wordSet'] = _wordSet;
    map['currentRound'] = _currentRound;
    map['timeLimit'] = _timeLimit;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['startedAt'] = _startedAt;
    map['finishedAt'] = _finishedAt;
    if (_players != null) {
      map['players'] = _players?.map((v) => v.toJson()).toList();
    }
    if (_creator != null) {
      map['creator'] = _creator?.toJson();
    }
    return map;
  }

}

Creator creatorFromJson(String str) => Creator.fromJson(json.decode(str));
String creatorToJson(Creator data) => json.encode(data.toJson());
class Creator {
  Creator({
      String? id, 
      String? username, 
      dynamic avatar, 
      String? firstName,}){
    _id = id;
    _username = username;
    _avatar = avatar;
    _firstName = firstName;
}

  Creator.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _avatar = json['avatar'];
    _firstName = json['firstName'];
  }
  String? _id;
  String? _username;
  dynamic _avatar;
  String? _firstName;

  String? get id => _id;
  String? get username => _username;
  dynamic get avatar => _avatar;
  String? get firstName => _firstName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['avatar'] = _avatar;
    map['firstName'] = _firstName;
    return map;
  }

}

Players playersFromJson(String str) => Players.fromJson(json.decode(str));
String playersToJson(Players data) => json.encode(data.toJson());
class Players {
  Players({
      String? id, 
      String? userId, 
      String? roomId, 
      String? status, 
      String? joinStatus, 
      int? position, 
      dynamic targetId, 
      dynamic characterId, 
      dynamic word1, 
      dynamic word2, 
      dynamic word3, 
      int? kills, 
      dynamic eliminatedAt, 
      String? createdAt, 
      String? updatedAt, 
      User? user,}){
    _id = id;
    _userId = userId;
    _roomId = roomId;
    _status = status;
    _joinStatus = joinStatus;
    _position = position;
    _targetId = targetId;
    _characterId = characterId;
    _word1 = word1;
    _word2 = word2;
    _word3 = word3;
    _kills = kills;
    _eliminatedAt = eliminatedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _user = user;
}

  Players.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['userId'];
    _roomId = json['roomId'];
    _status = json['status'];
    _joinStatus = json['joinStatus'];
    _position = json['position'];
    _targetId = json['targetId'];
    _characterId = json['characterId'];
    _word1 = json['word1'];
    _word2 = json['word2'];
    _word3 = json['word3'];
    _kills = json['kills'];
    _eliminatedAt = json['eliminatedAt'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? _id;
  String? _userId;
  String? _roomId;
  String? _status;
  String? _joinStatus;
  int? _position;
  dynamic _targetId;
  dynamic _characterId;
  dynamic _word1;
  dynamic _word2;
  dynamic _word3;
  int? _kills;
  dynamic _eliminatedAt;
  String? _createdAt;
  String? _updatedAt;
  User? _user;

  String? get id => _id;
  String? get userId => _userId;
  String? get roomId => _roomId;
  String? get status => _status;
  String? get joinStatus => _joinStatus;
  int? get position => _position;
  dynamic get targetId => _targetId;
  dynamic get characterId => _characterId;
  dynamic get word1 => _word1;
  dynamic get word2 => _word2;
  dynamic get word3 => _word3;
  int? get kills => _kills;
  dynamic get eliminatedAt => _eliminatedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userId'] = _userId;
    map['roomId'] = _roomId;
    map['status'] = _status;
    map['joinStatus'] = _joinStatus;
    map['position'] = _position;
    map['targetId'] = _targetId;
    map['characterId'] = _characterId;
    map['word1'] = _word1;
    map['word2'] = _word2;
    map['word3'] = _word3;
    map['kills'] = _kills;
    map['eliminatedAt'] = _eliminatedAt;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
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
      String? username, 
      dynamic avatar, 
      String? email, 
      String? firstName,}){
    _id = id;
    _username = username;
    _avatar = avatar;
    _email = email;
    _firstName = firstName;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _avatar = json['avatar'];
    _email = json['email'];
    _firstName = json['firstName'];
  }
  String? _id;
  String? _username;
  dynamic _avatar;
  String? _email;
  String? _firstName;

  String? get id => _id;
  String? get username => _username;
  dynamic get avatar => _avatar;
  String? get email => _email;
  String? get firstName => _firstName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['avatar'] = _avatar;
    map['email'] = _email;
    map['firstName'] = _firstName;
    return map;
  }

}