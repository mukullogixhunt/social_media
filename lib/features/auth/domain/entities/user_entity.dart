import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String bio;
  final String profileImageUrl;
  final Timestamp? createdAt;
  final Timestamp? lastSignIn;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.bio,
    required this.profileImageUrl,
    required this.createdAt,
    required this.lastSignIn,
  });

  @override
  List<Object?> get props => [uid, name, email, bio, profileImageUrl,createdAt,lastSignIn];
}
