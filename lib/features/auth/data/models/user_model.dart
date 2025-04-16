import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.bio,
    required super.profileImageUrl,
    required super.createdAt,
    required super.lastSignIn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      bio: json['bio'] ?? "",
      profileImageUrl: json['profileImageUrl'] ?? "",
      createdAt: json['createdAt'],
      lastSignIn: json['lastSignIn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
      'lastSignIn': lastSignIn,
    };
  }
}
