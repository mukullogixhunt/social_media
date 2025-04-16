import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/features/post/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.userId,
    required super.username,
    required super.message,
    required super.timestamp,
  });

  factory PostModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return PostModel(
      id: snap.id,
      userId: data['userId'] ?? '',
      username: data['username'] ?? 'Unknown User',
      message: data['message'] ?? '',
      
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'message': message,
      'timestamp': timestamp, 
    };
  }
}