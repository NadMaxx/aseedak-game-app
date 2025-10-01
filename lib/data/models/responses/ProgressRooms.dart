import 'dart:convert';
ProgressRooms progressRoomsFromJson(String str) => ProgressRooms.fromJson(json.decode(str));
String progressRoomsToJson(ProgressRooms data) => json.encode(data.toJson());
class ProgressRooms {
  ProgressRooms({
      List<Rooms>? rooms, 
      int? total,}){
    _rooms = rooms;
    _total = total;
}

  ProgressRooms.fromJson(dynamic json) {
    if (json['rooms'] != null) {
      _rooms = [];
      json['rooms'].forEach((v) {
        _rooms?.add(Rooms.fromJson(v));
      });
    }
    _total = json['total'];
  }
  List<Rooms>? _rooms;
  int? _total;

  List<Rooms>? get rooms => _rooms;
  int? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_rooms != null) {
      map['rooms'] = _rooms?.map((v) => v.toJson()).toList();
    }
    map['total'] = _total;
    return map;
  }

}

Rooms roomsFromJson(String str) => Rooms.fromJson(json.decode(str));
String roomsToJson(Rooms data) => json.encode(data.toJson());
class Rooms {
  Rooms({
      String? id, 
      String? name, 
      String? code, 
      int? maxPlayers, 
      String? status, 
      int? currentRound, 
      int? timeLimit, 
      int? playerCount, 
      int? totalPlayers, 
      Creator? creator, 
      String? userRole, 
      String? userJoinStatus, 
      int? userPosition, 
      String? userStatus, 
      UserTarget? userTarget, 
      int? userKills, 
      dynamic userEliminatedAt, 
      String? createdAt, 
      String? startedAt, 
      List<Players>? players,}){
    _id = id;
    _name = name;
    _code = code;
    _maxPlayers = maxPlayers;
    _status = status;
    _currentRound = currentRound;
    _timeLimit = timeLimit;
    _playerCount = playerCount;
    _totalPlayers = totalPlayers;
    _creator = creator;
    _userRole = userRole;
    _userJoinStatus = userJoinStatus;
    _userPosition = userPosition;
    _userStatus = userStatus;
    _userTarget = userTarget;
    _userKills = userKills;
    _userEliminatedAt = userEliminatedAt;
    _createdAt = createdAt;
    _startedAt = startedAt;
    _players = players;
}

  Rooms.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _maxPlayers = json['maxPlayers'];
    _status = json['status'];
    _currentRound = json['currentRound'];
    _timeLimit = json['timeLimit'];
    _playerCount = json['playerCount'];
    _totalPlayers = json['totalPlayers'];
    _creator = json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    _userRole = json['userRole'];
    _userJoinStatus = json['userJoinStatus'];
    _userPosition = json['userPosition'];
    _userStatus = json['userStatus'];
    _userTarget = json['userTarget'] != null ? UserTarget.fromJson(json['userTarget']) : null;
    _userKills = json['userKills'];
    _userEliminatedAt = json['userEliminatedAt'];
    _createdAt = json['createdAt'];
    _startedAt = json['startedAt'];
    if (json['players'] != null) {
      _players = [];
      json['players'].forEach((v) {
        _players?.add(Players.fromJson(v));
      });
    }
  }
  String? _id;
  String? _name;
  String? _code;
  int? _maxPlayers;
  String? _status;
  int? _currentRound;
  int? _timeLimit;
  int? _playerCount;
  int? _totalPlayers;
  Creator? _creator;
  String? _userRole;
  String? _userJoinStatus;
  int? _userPosition;
  String? _userStatus;
  UserTarget? _userTarget;
  int? _userKills;
  dynamic _userEliminatedAt;
  String? _createdAt;
  String? _startedAt;
  List<Players>? _players;

  String? get id => _id;
  String? get name => _name;
  String? get code => _code;
  int? get maxPlayers => _maxPlayers;
  String? get status => _status;
  int? get currentRound => _currentRound;
  int? get timeLimit => _timeLimit;
  int? get playerCount => _playerCount;
  int? get totalPlayers => _totalPlayers;
  Creator? get creator => _creator;
  String? get userRole => _userRole;
  String? get userJoinStatus => _userJoinStatus;
  int? get userPosition => _userPosition;
  String? get userStatus => _userStatus;
  UserTarget? get userTarget => _userTarget;
  int? get userKills => _userKills;
  dynamic get userEliminatedAt => _userEliminatedAt;
  String? get createdAt => _createdAt;
  String? get startedAt => _startedAt;
  List<Players>? get players => _players;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['maxPlayers'] = _maxPlayers;
    map['status'] = _status;
    map['currentRound'] = _currentRound;
    map['timeLimit'] = _timeLimit;
    map['playerCount'] = _playerCount;
    map['totalPlayers'] = _totalPlayers;
    if (_creator != null) {
      map['creator'] = _creator?.toJson();
    }
    map['userRole'] = _userRole;
    map['userJoinStatus'] = _userJoinStatus;
    map['userPosition'] = _userPosition;
    map['userStatus'] = _userStatus;
    if (_userTarget != null) {
      map['userTarget'] = _userTarget?.toJson();
    }
    map['userKills'] = _userKills;
    map['userEliminatedAt'] = _userEliminatedAt;
    map['createdAt'] = _createdAt;
    map['startedAt'] = _startedAt;
    if (_players != null) {
      map['players'] = _players?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Players playersFromJson(String str) => Players.fromJson(json.decode(str));
String playersToJson(Players data) => json.encode(data.toJson());
class Players {
  Players({
      String? id, 
      int? position, 
      String? status, 
      String? joinStatus, 
      int? kills, 
      User? user, 
      Target? target,}){
    _id = id;
    _position = position;
    _status = status;
    _joinStatus = joinStatus;
    _kills = kills;
    _user = user;
    _target = target;
}

  Players.fromJson(dynamic json) {
    _id = json['id'];
    _position = json['position'];
    _status = json['status'];
    _joinStatus = json['joinStatus'];
    _kills = json['kills'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _target = json['target'] != null ? Target.fromJson(json['target']) : null;
  }
  String? _id;
  int? _position;
  String? _status;
  String? _joinStatus;
  int? _kills;
  User? _user;
  Target? _target;

  String? get id => _id;
  int? get position => _position;
  String? get status => _status;
  String? get joinStatus => _joinStatus;
  int? get kills => _kills;
  User? get user => _user;
  Target? get target => _target;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['position'] = _position;
    map['status'] = _status;
    map['joinStatus'] = _joinStatus;
    map['kills'] = _kills;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_target != null) {
      map['target'] = _target?.toJson();
    }
    return map;
  }

}

Target targetFromJson(String str) => Target.fromJson(json.decode(str));
String targetToJson(Target data) => json.encode(data.toJson());
class Target {
  Target({
      String? id, 
      int? position, 
      String? status, 
      User? user,}){
    _id = id;
    _position = position;
    _status = status;
    _user = user;
}

  Target.fromJson(dynamic json) {
    _id = json['id'];
    _position = json['position'];
    _status = json['status'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? _id;
  int? _position;
  String? _status;
  User? _user;

  String? get id => _id;
  int? get position => _position;
  String? get status => _status;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['position'] = _position;
    map['status'] = _status;
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
      String? avatar,}){
    _id = id;
    _username = username;
    _avatar = avatar;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _avatar = json['avatar'];
  }
  String? _id;
  String? _username;
  String? _avatar;

  String? get id => _id;
  String? get username => _username;
  String? get avatar => _avatar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['avatar'] = _avatar;
    return map;
  }

}


UserTarget userTargetFromJson(String str) => UserTarget.fromJson(json.decode(str));
String userTargetToJson(UserTarget data) => json.encode(data.toJson());
class UserTarget {
  UserTarget({
      String? id, 
      int? position, 
      String? status, 
      User? user,}){
    _id = id;
    _position = position;
    _status = status;
    _user = user;
}

  UserTarget.fromJson(dynamic json) {
    _id = json['id'];
    _position = json['position'];
    _status = json['status'];
    // _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? _id;
  int? _position;
  String? _status;
  User? _user;

  String? get id => _id;
  int? get position => _position;
  String? get status => _status;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['position'] = _position;
    map['status'] = _status;
    if (_user != null) {
      map['user'] = _user?.toJson();
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
      String? firstName, 
      String? lastName, 
      dynamic avatar,}){
    _id = id;
    _username = username;
    _firstName = firstName;
    _lastName = lastName;
    _avatar = avatar;
}

  Creator.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _avatar = json['avatar'];
  }
  String? _id;
  String? _username;
  String? _firstName;
  String? _lastName;
  dynamic _avatar;

  String? get id => _id;
  String? get username => _username;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  dynamic get avatar => _avatar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['avatar'] = _avatar;
    return map;
  }

}