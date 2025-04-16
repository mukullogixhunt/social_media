part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

// Event to trigger loading/subscribing to posts
class LoadPosts extends PostEvent {}

// Event when new posts arrive from the stream
class PostsUpdated extends PostEvent {
  final List<PostEntity> posts;
  const PostsUpdated(this.posts);

  @override
  List<Object> get props => [posts];
}

// Event to add a new post
class AddPost extends PostEvent {
  final String message;
  // We'll get username/userId from Auth state or Firebase instance later
  const AddPost({required this.message});

  @override
  List<Object> get props => [message];
}
