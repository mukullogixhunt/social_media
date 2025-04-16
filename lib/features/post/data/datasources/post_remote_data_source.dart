import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/features/post/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<void> addPost(String message, String username, String userId);
  Stream<List<PostModel>> getPostsStream();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirebaseFirestore firestore;

  PostRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> addPost(String message, String username, String userId) async {
    await firestore.collection('posts').add({
      'userId': userId,
      'username': username,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(), 
    });
  }

  @override
  Stream<List<PostModel>> getPostsStream() {
    return firestore
        .collection('posts')
        .orderBy('timestamp', descending: true) 
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => PostModel.fromSnapshot(doc)).toList();
    });
  }
}