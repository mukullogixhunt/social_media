import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id; // Firestore document ID
  final String userId;
  final String username;
  final String message;
  final Timestamp timestamp;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.username,
    required this.message,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, userId, username, message, timestamp];
}