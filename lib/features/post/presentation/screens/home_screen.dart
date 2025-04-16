import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:social_media/core/extentions/context_extensions.dart';
import 'package:social_media/features/auth/presentation/screens/login_screen.dart';

import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/post_entity.dart';
import '../bloc/post_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String path = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _postController = TextEditingController();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  void _addPost() {
    final message = _postController.text.trim();
    if (message.isNotEmpty) {
      context.read<PostBloc>().add(AddPost(message: message));
      _postController.clear(); 
      FocusScope.of(context).unfocus(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (context) => sl<PostBloc>()..add(LoadPosts()), 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Social Feed'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                
                context.read<AuthBloc>().add(SignOut());
              },
            ),
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Unauthenticated) {
                  
                  context.go(LoginScreen.path);
                }
              },
            ),
            
            BlocListener<PostBloc, PostState>(
              listener: (context, state) {
                if (state is PostError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Post Error: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is PostAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Post Added Successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
          child: Column(
            children: [
              
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _postController,
                        decoration: const InputDecoration(
                          hintText: 'What\'s on your mind?',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null, 
                      ),
                    ),
                    const SizedBox(width: 8),
                    BlocBuilder<PostBloc, PostState>(
                        builder: (context, state) {
                          
                          final bool isAdding = state is PostAdding;
                          return IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: isAdding ? null : _addPost,
                            color: context.theme.primaryColor,
                            tooltip: 'Post Message',
                          );
                        }
                    )
                  ],
                ),
              ),
              const Divider(),
              
              Expanded(
                child: BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    if (state is PostLoading && state is! PostLoaded) {
                      
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PostLoaded || state is PostAdding || state is PostAdded) {
                      
                      List<PostEntity> posts = [];
                      if (state is PostLoaded) posts = state.posts;

                      if (posts.isEmpty) {
                        return const Center(child: Text('No posts yet. Be the first!'));
                      }
                      return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          
                          final formattedDate = DateFormat('MMM d, yyyy - hh:mm a')
                              .format(post.timestamp.toDate());

                          return ListTile(
                            title: Text(post.message),
                            subtitle: Text(
                              'By ${post.username} on $formattedDate',
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                            
                          );
                        },
                      );
                    } else if (state is PostError) {
                      return Center(child: Text('Error loading posts: ${state.message}'));
                    }
                    return const Center(child: Text('Something went wrong.')); 
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
