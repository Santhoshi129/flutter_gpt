class Message {
  Message({
    this.image,
    this.profile,
    this.baseData,
    this.status,
    required this.timestamp,
    required this.type,
    required this.message,
    required this.userId,
    required this.userName,
  });

  Map<String, dynamic>? image;
  String? profile;
  late String type;
  late String message;
  late DateTime timestamp;
  late String userId;
  late String userName;
  bool? status = false;
  String? baseData;

  Message.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    baseData = json['baseData'];
    message = json['message'];
    image = json['image'];
    profile = json['profile'];
    timestamp = json['timestamp'];
    type = json['type'];
    userId = json['userId'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> object = {};
    object['status'] = status;
    object['baseData'] = baseData;
    object['message'] = message;
    object['image'] = image;
    object['profile'] = profile;
    object['timestamp'] = timestamp;
    object['type'] = type;
    object['userId'] = userId;
    object['userName'] = userName;
    return object;
  }
}
