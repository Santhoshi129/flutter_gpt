class User {
  User({
    required this.profile,
    required this.userId,
    required this.userName,
  });
  late String profile;
  late String userId;
  late String userName;

  User.fromJson(Map<String, dynamic> json) {
    profile = json['profile'];
    userId = json['userId'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> object = {};
    object['profile'] = profile;
    object['userId'] = userId;
    object['userName'] = userName;
    return object;
  }
}
