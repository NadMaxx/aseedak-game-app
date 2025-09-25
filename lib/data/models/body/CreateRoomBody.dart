import 'dart:convert';
CreateRoomBody createRoomBodyFromJson(String str) => CreateRoomBody.fromJson(json.decode(str));
String createRoomBodyToJson(CreateRoomBody data) => json.encode(data.toJson());
class CreateRoomBody {
  CreateRoomBody({
      String? name, 
      int? maxPlayers, 
      String? difficulty, 
      String? category, 
      int? timeLimit, 
      List<String>? invitedUsers,}){
    _name = name;
    _maxPlayers = maxPlayers;
    _difficulty = difficulty;
    _category = category;
    _timeLimit = timeLimit;
    _invitedUsers = invitedUsers;
}

  CreateRoomBody.fromJson(dynamic json) {
    _name = json['name'];
    _maxPlayers = json['maxPlayers'];
    _difficulty = json['difficulty'];
    _category = json['category'];
    _timeLimit = json['timeLimit'];
    _invitedUsers = json['invitedUsers'] != null ? json['invitedUsers'].cast<String>() : [];
  }
  String? _name;
  int? _maxPlayers;
  String? _difficulty;
  String? _category;
  int? _timeLimit;
  List<String>? _invitedUsers;

  String? get name => _name;
  int? get maxPlayers => _maxPlayers;
  String? get difficulty => _difficulty;
  String? get category => _category;
  int? get timeLimit => _timeLimit;
  List<String>? get invitedUsers => _invitedUsers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['maxPlayers'] = _maxPlayers;
    // map['difficulty'] = _difficulty;
    // map['category'] = _category;
    map['timeLimit'] = _timeLimit;
    map['invitedUsers'] = _invitedUsers;
    return map;
  }

}