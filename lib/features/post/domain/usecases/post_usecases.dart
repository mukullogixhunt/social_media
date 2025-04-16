import 'package:dartz/dartz.dart';
import 'package:social_media/core/error/failure.dart';
import 'package:social_media/core/usecase/usecase.dart';
import 'package:social_media/features/post/domain/entities/post_entity.dart';
import 'package:social_media/features/post/domain/repositories/post_repository.dart';

class AddPostUseCase implements UseCase<void, AddPostParams> {
  final PostRepository repository;
  AddPostUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddPostParams params) {
    return repository.addPost(params.message, params.username, params.userId);
  }
}

class AddPostParams {
  final String message;
  final String username;
  final String userId;
  AddPostParams({required this.message, required this.username, required this.userId});
}

// UseCase for getting the stream
class GetPostsStreamUseCase implements UseCase<Stream<List<PostEntity>>, NoParams> {
  final PostRepository repository;
  GetPostsStreamUseCase(this.repository);

  @override
  // Modified call signature for stream use case
  Future<Either<Failure, Stream<List<PostEntity>>>> call(NoParams params) async {
    return repository.getPostsStream();
  }
}