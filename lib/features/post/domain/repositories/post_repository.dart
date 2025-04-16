import 'package:dartz/dartz.dart';
import 'package:social_media/core/error/failure.dart';
import 'package:social_media/features/post/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<Either<Failure, void>> addPost(String message, String username, String userId);

  Either<Failure, Stream<List<PostEntity>>> getPostsStream();
}