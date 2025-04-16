import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:social_media/core/error/failure.dart';
import 'package:social_media/features/post/data/datasources/post_remote_data_source.dart';
import 'package:social_media/features/post/domain/entities/post_entity.dart';
import 'package:social_media/features/post/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addPost(String message, String username, String userId) async {
    try {
      await remoteDataSource.addPost(message, username, userId);
      return const Right(null);
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      print("Error adding post: $e");
      return Left(UnexpectedFailure(message: 'Failed to add post: ${e.toString()}'));
    }
  }

  @override
  Either<Failure, Stream<List<PostEntity>>> getPostsStream() {
    try {
      
      
      final stream = remoteDataSource.getPostsStream();
      return Right(stream);
    } catch (e) {
      print("Error getting post stream: $e");
      return Left(UnexpectedFailure(message: 'Failed to get posts stream: ${e.toString()}'));
    }
  }
}