import 'dart:convert';

class User {
  int? userId;
  String? username;
  String? email;
  String? token;
  String? profile;
  String? phoneNumber;
  String? dateJoined;
  User({this.userId, this.username, this.email, this.token, this.profile, this.phoneNumber, this.dateJoined});

  User copyWith({int? userId, String? username, String? email, String? token, String? profile, String? phoneNumber, String? dateJoined}) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      token: token ?? this.token,
      profile: profile ?? this.profile,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateJoined: dateJoined ?? this.dateJoined,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'token': token,
      'profile': profile,
      'phoneNumber': phoneNumber,
      'dateJoined': dateJoined,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      username: map['username'],
      email: map['email'],
      token: map['token'],
      profile: map['profile'],
      phoneNumber: map['phoneNumber'],
      dateJoined: map['dateJoined'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(userId: $userId, username: $username, email: $email, token: $token, profile: $profile, phoneNumber: $phoneNumber, dateJoined: $dateJoined)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.userId == userId &&
        other.username == username &&
        other.email == email &&
        other.token == token &&
        other.profile == profile &&
        other.phoneNumber == phoneNumber &&
        other.dateJoined == dateJoined;
  }

  @override
  int get hashCode {
    return userId.hashCode ^ username.hashCode ^ email.hashCode ^ token.hashCode ^ profile.hashCode ^ phoneNumber.hashCode ^ dateJoined.hashCode;
  }
}
