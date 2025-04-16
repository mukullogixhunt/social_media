import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/post_usecases.dart';

part 'post_event.dart';

part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final AddPostUseCase addPostUseCase;
  final GetPostsStreamUseCase getPostsStreamUseCase;
  final FirebaseFirestore firestore; 
  final FirebaseAuth firebaseAuth; 

  StreamSubscription? _postsSubscription;


  PostBloc({
    required this.addPostUseCase,
    required this.getPostsStreamUseCase,
    required this.firestore,
    required this.firebaseAuth,
  }) : super(PostInitial()) {
    on<PostEvent>((event, emit) {
    });
    on<LoadPosts>(_onLoadPosts);
    on<PostsUpdated>(_onPostsUpdated);
    on<AddPost>(_onAddPost);
  }
  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(PostLoading());
    await _postsSubscription?.cancel(); 
    final streamResult = await getPostsStreamUseCase(NoParams());

    streamResult.fold(
          (failure) => emit(PostError(mapFailureToMessage(failure))),
          (stream) {
        _postsSubscription = stream.listen(
              (posts) => add(PostsUpdated(posts)), 
          onError: (error) => emit(PostError("Error in posts stream: $error")),
        );
      },
    );
  }

  void _onPostsUpdated(PostsUpdated event, Emitter<PostState> emit) {
    emit(PostLoaded(event.posts));
  }

  Future<void> _onAddPost(AddPost event, Emitter<PostState> emit) async {
    
    final user = firebaseAuth.currentUser;
    if (user == null) {
      emit(const PostError("User not logged in. Cannot post."));
      return;
    }

    
    String username = "Unknown User"; 
    try {
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data()!.containsKey('name')) {
        username = userDoc.data()!['name'] as String;
      } else {
        
        print("Warning: User document or name not found for UID: ${user.uid}");
        username = user.displayName ?? user.email ?? "User ${user.uid.substring(0, 5)}";
      }
    } catch (e) {
      print("Error fetching username: $e");
      emit(PostError("Could not fetch user details to post."));
      return; 
    }


    
    emit(PostAdding()); 

    final result = await addPostUseCase(AddPostParams(
      message: event.message,
      username: username,
      userId: user.uid,
    ));

    result.fold(
          (failure) {
        print("AddPost Failure: $failure");
        emit(PostError(mapFailureToMessage(failure)));
      },
          (_) {
        print("AddPost Success");
        emit(PostAdded()); 
        
        
        
        
        
      },
    );
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}
