import 'package:get_it/get_it.dart';
import 'package:social_media/features/post/presentation/bloc/post_bloc.dart';

import 'data/datasources/post_remote_data_source.dart';
import 'data/repositories/post_repository_impl.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/usecases/post_usecases.dart';

final sl = GetIt.instance;

void initPost() {
  /// Post Use Cases Injection

  sl.registerLazySingleton(() => AddPostUseCase(sl()));
  sl.registerLazySingleton(() => GetPostsStreamUseCase(sl()));

  /// Post Repository Injection

  sl.registerLazySingleton<PostRepository>(
          () => PostRepositoryImpl(remoteDataSource: sl()));

  /// Post Data sources Injection
  sl.registerLazySingleton<PostRemoteDataSource>(
          () => PostRemoteDataSourceImpl(firestore: sl()));

  /// Post  Bloc Injection
  sl.registerFactory(() => PostBloc(
    addPostUseCase: sl(),
    getPostsStreamUseCase: sl(),
    firestore: sl(),
    firebaseAuth: sl(),
  ));
}
