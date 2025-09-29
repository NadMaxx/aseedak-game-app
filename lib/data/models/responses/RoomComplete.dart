import 'dart:convert';
RoomComplete roomCompleteFromJson(String str) => RoomComplete.fromJson(json.decode(str));
String roomCompleteToJson(RoomComplete data) => json.encode(data.toJson());
class RoomComplete {
  RoomComplete({
      bool? success, 
      Room? room,}){
    _success = success;
    _room = room;
}

  RoomComplete.fromJson(dynamic json) {
    _success = json['success'];
    _room = json['room'] != null ? Room.fromJson(json['room']) : null;
  }
  bool? _success;
  Room? _room;

  bool? get success => _success;
  Room? get room => _room;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_room != null) {
      map['room'] = _room?.toJson();
    }
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
      int? currentRound, 
      int? timeLimit, 
      String? createdAt, 
      String? startedAt, 
      String? updatedAt, 
      Creator? creator, 
      Statistics? statistics, 
      WordSet? wordSet, 
      List<Players>? players, 
      List<GameLogs>? gameLogs, 
      List<RecentActivity>? recentActivity, 
      List<dynamic>? killConfirmations, 
      CurrentUser? currentUser,}){
    _id = id;
    _name = name;
    _code = code;
    _maxPlayers = maxPlayers;
    _status = status;
    _currentRound = currentRound;
    _timeLimit = timeLimit;
    _createdAt = createdAt;
    _startedAt = startedAt;
    _updatedAt = updatedAt;
    _creator = creator;
    _statistics = statistics;
    _wordSet = wordSet;
    _players = players;
    _gameLogs = gameLogs;
    _recentActivity = recentActivity;
    _killConfirmations = killConfirmations;
    _currentUser = currentUser;
}

  Room.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _code = json['code'];
    _maxPlayers = json['maxPlayers'];
    _status = json['status'];
    _currentRound = json['currentRound'];
    _timeLimit = json['timeLimit'];
    _createdAt = json['createdAt'];
    _startedAt = json['startedAt'];
    _updatedAt = json['updatedAt'];
    _creator = json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    _statistics = json['statistics'] != null ? Statistics.fromJson(json['statistics']) : null;
    _wordSet = json['wordSet'] != null ? WordSet.fromJson(json['wordSet']) : null;
    if (json['players'] != null) {
      _players = [];
      json['players'].forEach((v) {
        _players?.add(Players.fromJson(v));
      });
    }
    if (json['gameLogs'] != null) {
      _gameLogs = [];
      json['gameLogs'].forEach((v) {
        _gameLogs?.add(GameLogs.fromJson(v));
      });
    }
    if (json['recentActivity'] != null) {
      _recentActivity = [];
      json['recentActivity'].forEach((v) {
        _recentActivity?.add(RecentActivity.fromJson(v));
      });
    }
    if (json['killConfirmations'] != null) {
      _killConfirmations = [];
      json['killConfirmations'].forEach((v) {
        // _killConfirmations?.add(Dynamic.fromJson(v));
      });
    }
    _currentUser = json['currentUser'] != null ? CurrentUser.fromJson(json['currentUser']) : null;
  }
  String? _id;
  String? _name;
  String? _code;
  int? _maxPlayers;
  String? _status;
  int? _currentRound;
  int? _timeLimit;
  String? _createdAt;
  String? _startedAt;
  String? _updatedAt;
  Creator? _creator;
  Statistics? _statistics;
  WordSet? _wordSet;
  List<Players>? _players;
  List<GameLogs>? _gameLogs;
  List<RecentActivity>? _recentActivity;
  List<dynamic>? _killConfirmations;
  CurrentUser? _currentUser;

  String? get id => _id;
  String? get name => _name;
  String? get code => _code;
  int? get maxPlayers => _maxPlayers;
  String? get status => _status;
  int? get currentRound => _currentRound;
  int? get timeLimit => _timeLimit;
  String? get createdAt => _createdAt;
  String? get startedAt => _startedAt;
  String? get updatedAt => _updatedAt;
  Creator? get creator => _creator;
  Statistics? get statistics => _statistics;
  WordSet? get wordSet => _wordSet;
  List<Players>? get players => _players;
  List<GameLogs>? get gameLogs => _gameLogs;
  List<RecentActivity>? get recentActivity => _recentActivity;
  List<dynamic>? get killConfirmations => _killConfirmations;
  CurrentUser? get currentUser => _currentUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['code'] = _code;
    map['maxPlayers'] = _maxPlayers;
    map['status'] = _status;
    map['currentRound'] = _currentRound;
    map['timeLimit'] = _timeLimit;
    map['createdAt'] = _createdAt;
    map['startedAt'] = _startedAt;
    map['updatedAt'] = _updatedAt;
    if (_creator != null) {
      map['creator'] = _creator?.toJson();
    }
    if (_statistics != null) {
      map['statistics'] = _statistics?.toJson();
    }
    if (_wordSet != null) {
      map['wordSet'] = _wordSet?.toJson();
    }
    if (_players != null) {
      map['players'] = _players?.map((v) => v.toJson()).toList();
    }
    if (_gameLogs != null) {
      map['gameLogs'] = _gameLogs?.map((v) => v.toJson()).toList();
    }
    if (_recentActivity != null) {
      map['recentActivity'] = _recentActivity?.map((v) => v.toJson()).toList();
    }
    if (_killConfirmations != null) {
      map['killConfirmations'] = _killConfirmations?.map((v) => v.toJson()).toList();
    }
    if (_currentUser != null) {
      map['currentUser'] = _currentUser?.toJson();
    }
    return map;
  }

}

CurrentUser currentUserFromJson(String str) => CurrentUser.fromJson(json.decode(str));
String currentUserToJson(CurrentUser data) => json.encode(data.toJson());
class CurrentUser {
  CurrentUser({
      String? playerId, 
      int? position, 
      String? status, 
      String? joinStatus, 
      int? kills, 
      bool? isCreator, 
      Target? target, 
      Character? character, 
      Words? words, 
      List<dynamic>? pendingConfirmations,}){
    _playerId = playerId;
    _position = position;
    _status = status;
    _joinStatus = joinStatus;
    _kills = kills;
    _isCreator = isCreator;
    _target = target;
    _character = character;
    _words = words;
    _pendingConfirmations = pendingConfirmations;
}

  CurrentUser.fromJson(dynamic json) {
    _playerId = json['playerId'];
    _position = json['position'];
    _status = json['status'];
    _joinStatus = json['joinStatus'];
    _kills = json['kills'];
    _isCreator = json['isCreator'];
    _target = json['target'] != null ? Target.fromJson(json['target']) : null;
    _character = json['character'] != null ? Character.fromJson(json['character']) : null;
    _words = json['words'] != null ? Words.fromJson(json['words']) : null;
    if (json['pendingConfirmations'] != null) {
      _pendingConfirmations = [];
      json['pendingConfirmations'].forEach((v) {
        // _pendingConfirmations?.add(Dynamic.fromJson(v));
      });
    }
  }
  String? _playerId;
  int? _position;
  String? _status;
  String? _joinStatus;
  int? _kills;
  bool? _isCreator;
  Target? _target;
  Character? _character;
  Words? _words;
  List<dynamic>? _pendingConfirmations;

  String? get playerId => _playerId;
  int? get position => _position;
  String? get status => _status;
  String? get joinStatus => _joinStatus;
  int? get kills => _kills;
  bool? get isCreator => _isCreator;
  Target? get target => _target;
  Character? get character => _character;
  Words? get words => _words;
  List<dynamic>? get pendingConfirmations => _pendingConfirmations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['playerId'] = _playerId;
    map['position'] = _position;
    map['status'] = _status;
    map['joinStatus'] = _joinStatus;
    map['kills'] = _kills;
    map['isCreator'] = _isCreator;
    if (_target != null) {
      map['target'] = _target?.toJson();
    }
    if (_character != null) {
      map['character'] = _character?.toJson();
    }
    if (_words != null) {
      map['words'] = _words?.toJson();
    }
    if (_pendingConfirmations != null) {
      map['pendingConfirmations'] = _pendingConfirmations?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

Words wordsFromJson(String str) => Words.fromJson(json.decode(str));
String wordsToJson(Words data) => json.encode(data.toJson());
class Words {
  Words({
      String? word1, 
      String? word2, 
      String? word3,}){
    _word1 = word1;
    _word2 = word2;
    _word3 = word3;
}

  Words.fromJson(dynamic json) {
    _word1 = json['word1'];
    _word2 = json['word2'];
    _word3 = json['word3'];
  }
  String? _word1;
  String? _word2;
  String? _word3;

  String? get word1 => _word1;
  String? get word2 => _word2;
  String? get word3 => _word3;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['word1'] = _word1;
    map['word2'] = _word2;
    map['word3'] = _word3;
    return map;
  }

}

Character characterFromJson(String str) => Character.fromJson(json.decode(str));
String characterToJson(Character data) => json.encode(data.toJson());
class Character {
  Character({
      String? id, 
      String? name, 
      String? description, 
      String? imageUrl, 
      bool? isActive,}){
    _id = id;
    _name = name;
    _description = description;
    _imageUrl = imageUrl;
    _isActive = isActive;
}

  Character.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _imageUrl = json['imageUrl'];
    _isActive = json['isActive'];
  }
  String? _id;
  String? _name;
  String? _description;
  String? _imageUrl;
  bool? _isActive;

  String? get id => _id;
  String? get name => _name;
  String? get description => _description;
  String? get imageUrl => _imageUrl;
  bool? get isActive => _isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['imageUrl'] = _imageUrl;
    map['isActive'] = _isActive;
    return map;
  }

}

Target targetFromJson(String str) => Target.fromJson(json.decode(str));
String targetToJson(Target data) => json.encode(data.toJson());
class Target {
  Target({
      String? id, 
      User? user,}){
    _id = id;
    _user = user;
}

  Target.fromJson(dynamic json) {
    _id = json['id'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? _id;
  User? _user;

  String? get id => _id;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }

}



RecentActivity recentActivityFromJson(String str) => RecentActivity.fromJson(json.decode(str));
String recentActivityToJson(RecentActivity data) => json.encode(data.toJson());
class RecentActivity {
  RecentActivity({
      String? id, 
      String? type, 
      String? message, 
      String? createdAt,}){
    _id = id;
    _type = type;
    _message = message;
    _createdAt = createdAt;
}

  RecentActivity.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _message = json['message'];
    _createdAt = json['createdAt'];
  }
  String? _id;
  String? _type;
  String? _message;
  String? _createdAt;

  String? get id => _id;
  String? get type => _type;
  String? get message => _message;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['message'] = _message;
    map['createdAt'] = _createdAt;
    return map;
  }

}

GameLogs gameLogsFromJson(String str) => GameLogs.fromJson(json.decode(str));
String gameLogsToJson(GameLogs data) => json.encode(data.toJson());
class GameLogs {
  GameLogs({
      String? id, 
      String? type, 
      String? message, 
      Data? data, 
      String? createdAt, 
      dynamic player, 
      dynamic target,}){
    _id = id;
    _type = type;
    _message = message;
    _data = data;
    _createdAt = createdAt;
    _player = player;
    _target = target;
}

  GameLogs.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _createdAt = json['createdAt'];
    _player = json['player'];
    _target = json['target'];
  }
  String? _id;
  String? _type;
  String? _message;
  Data? _data;
  String? _createdAt;
  dynamic _player;
  dynamic _target;

  String? get id => _id;
  String? get type => _type;
  String? get message => _message;
  Data? get data => _data;
  String? get createdAt => _createdAt;
  dynamic get player => _player;
  dynamic get target => _target;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['createdAt'] = _createdAt;
    map['player'] = _player;
    map['target'] = _target;
    return map;
  }

}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      int? playerCount, 
      int? wordCount,}){
    _playerCount = playerCount;
    _wordCount = wordCount;
}

  Data.fromJson(dynamic json) {
    _playerCount = json['playerCount'];
    _wordCount = json['wordCount'];
  }
  int? _playerCount;
  int? _wordCount;

  int? get playerCount => _playerCount;
  int? get wordCount => _wordCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['playerCount'] = _playerCount;
    map['wordCount'] = _wordCount;
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
      String? createdAt, 
      String? updatedAt, 
      User? user, 
      Target? target, 
      Character? character, 
      Words? words, 
      PendingConfirmations? pendingConfirmations,}){
    _id = id;
    _position = position;
    _status = status;
    _joinStatus = joinStatus;
    _kills = kills;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _user = user;
    _target = target;
    _character = character;
    _words = words;
    _pendingConfirmations = pendingConfirmations;
}

  Players.fromJson(dynamic json) {
    _id = json['id'];
    _position = json['position'];
    _status = json['status'];
    _joinStatus = json['joinStatus'];
    _kills = json['kills'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _target = json['target'] != null ? Target.fromJson(json['target']) : null;
    _character = json['character'] != null ? Character.fromJson(json['character']) : null;
    _words = json['words'] != null ? Words.fromJson(json['words']) : null;
    _pendingConfirmations = json['pendingConfirmations'] != null ? PendingConfirmations.fromJson(json['pendingConfirmations']) : null;
  }
  String? _id;
  int? _position;
  String? _status;
  String? _joinStatus;
  int? _kills;
  String? _createdAt;
  String? _updatedAt;
  User? _user;
  Target? _target;
  Character? _character;
  Words? _words;
  PendingConfirmations? _pendingConfirmations;

  String? get id => _id;
  int? get position => _position;
  String? get status => _status;
  String? get joinStatus => _joinStatus;
  int? get kills => _kills;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  User? get user => _user;
  Target? get target => _target;
  Character? get character => _character;
  Words? get words => _words;
  PendingConfirmations? get pendingConfirmations => _pendingConfirmations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['position'] = _position;
    map['status'] = _status;
    map['joinStatus'] = _joinStatus;
    map['kills'] = _kills;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_target != null) {
      map['target'] = _target?.toJson();
    }
    if (_character != null) {
      map['character'] = _character?.toJson();
    }
    if (_words != null) {
      map['words'] = _words?.toJson();
    }
    if (_pendingConfirmations != null) {
      map['pendingConfirmations'] = _pendingConfirmations?.toJson();
    }
    return map;
  }

}

PendingConfirmations pendingConfirmationsFromJson(String str) => PendingConfirmations.fromJson(json.decode(str));
String pendingConfirmationsToJson(PendingConfirmations data) => json.encode(data.toJson());
class PendingConfirmations {
  PendingConfirmations({
      List<dynamic>? asKiller, 
      List<dynamic>? asTarget,}){
    _asKiller = asKiller;
    _asTarget = asTarget;
}

  PendingConfirmations.fromJson(dynamic json) {
    if (json['asKiller'] != null) {
      _asKiller = [];
      json['asKiller'].forEach((v) {
        // _asKiller?.add(Dynamic.fromJson(v));
      });
    }
    if (json['asTarget'] != null) {
      _asTarget = [];
      json['asTarget'].forEach((v) {
        // _asTarget?.add(Dynamic.fromJson(v));
      });
    }
  }
  List<dynamic>? _asKiller;
  List<dynamic>? _asTarget;

  List<dynamic>? get asKiller => _asKiller;
  List<dynamic>? get asTarget => _asTarget;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_asKiller != null) {
      map['asKiller'] = _asKiller?.map((v) => v.toJson()).toList();
    }
    if (_asTarget != null) {
      map['asTarget'] = _asTarget?.map((v) => v.toJson()).toList();
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
      String? avatar, 
      String? email, 
      String? firstName, 
      String? lastName,}){
    _id = id;
    _username = username;
    _avatar = avatar;
    _email = email;
    _firstName = firstName;
    _lastName = lastName;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _avatar = json['avatar'];
    _email = json['email'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
  }
  String? _id;
  String? _username;
  String? _avatar;
  String? _email;
  String? _firstName;
  String? _lastName;

  String? get id => _id;
  String? get username => _username;
  String? get avatar => _avatar;
  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['avatar'] = _avatar;
    map['email'] = _email;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    return map;
  }

}

WordSet wordSetFromJson(String str) => WordSet.fromJson(json.decode(str));
String wordSetToJson(WordSet data) => json.encode(data.toJson());
class WordSet {
  WordSet({
      List<String>? wordIds, 
      List<Words>? words,}){
    _wordIds = wordIds;
    _words = words;
}

  WordSet.fromJson(dynamic json) {
    _wordIds = json['wordIds'] != null ? json['wordIds'].cast<String>() : [];
    if (json['words'] != null) {
      _words = [];
      json['words'].forEach((v) {
        _words?.add(Words.fromJson(v));
      });
    }
  }
  List<String>? _wordIds;
  List<Words>? _words;

  List<String>? get wordIds => _wordIds;
  List<Words>? get words => _words;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['wordIds'] = _wordIds;
    if (_words != null) {
      map['words'] = _words?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


Statistics statisticsFromJson(String str) => Statistics.fromJson(json.decode(str));
String statisticsToJson(Statistics data) => json.encode(data.toJson());
class Statistics {
  Statistics({
      int? totalPlayers, 
      int? joinedPlayers, 
      int? pendingPlayers, 
      int? alivePlayers, 
      int? eliminatedPlayers, 
      int? totalKills, 
      int? gameDuration,}){
    _totalPlayers = totalPlayers;
    _joinedPlayers = joinedPlayers;
    _pendingPlayers = pendingPlayers;
    _alivePlayers = alivePlayers;
    _eliminatedPlayers = eliminatedPlayers;
    _totalKills = totalKills;
    _gameDuration = gameDuration;
}

  Statistics.fromJson(dynamic json) {
    _totalPlayers = json['totalPlayers'];
    _joinedPlayers = json['joinedPlayers'];
    _pendingPlayers = json['pendingPlayers'];
    _alivePlayers = json['alivePlayers'];
    _eliminatedPlayers = json['eliminatedPlayers'];
    _totalKills = json['totalKills'];
    _gameDuration = json['gameDuration'];
  }
  int? _totalPlayers;
  int? _joinedPlayers;
  int? _pendingPlayers;
  int? _alivePlayers;
  int? _eliminatedPlayers;
  int? _totalKills;
  int? _gameDuration;

  int? get totalPlayers => _totalPlayers;
  int? get joinedPlayers => _joinedPlayers;
  int? get pendingPlayers => _pendingPlayers;
  int? get alivePlayers => _alivePlayers;
  int? get eliminatedPlayers => _eliminatedPlayers;
  int? get totalKills => _totalKills;
  int? get gameDuration => _gameDuration;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalPlayers'] = _totalPlayers;
    map['joinedPlayers'] = _joinedPlayers;
    map['pendingPlayers'] = _pendingPlayers;
    map['alivePlayers'] = _alivePlayers;
    map['eliminatedPlayers'] = _eliminatedPlayers;
    map['totalKills'] = _totalKills;
    map['gameDuration'] = _gameDuration;
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
      String? firstName, 
      String? lastName,}){
    _id = id;
    _username = username;
    _avatar = avatar;
    _firstName = firstName;
    _lastName = lastName;
}

  Creator.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _avatar = json['avatar'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
  }
  String? _id;
  String? _username;
  dynamic _avatar;
  String? _firstName;
  String? _lastName;

  String? get id => _id;
  String? get username => _username;
  dynamic get avatar => _avatar;
  String? get firstName => _firstName;
  String? get lastName => _lastName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['avatar'] = _avatar;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    return map;
  }

}