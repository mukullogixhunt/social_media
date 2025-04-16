import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_media/features/auth/presentation/widgets/my_button.dart';
import 'package:social_media/features/auth/presentation/widgets/validated_text_field.dart';
import 'package:social_media/core/extentions/context_extensions.dart';

import '../../../../core/utlis/full_screen_loader.dart';
import '../../../post/presentation/screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  static const path = '/signup';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        SignUpWithEmail(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const FullScreenLoader(),
              );
            } else {
              Navigator.of(context, rootNavigator: true).pop(); // close dialog
              if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is Authenticated) {
                context.go(HomeScreen.path);
              }
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Icon(
                    Icons.lock_open_rounded,
                    size: 80,
                    color: context.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Let's get you signed up!",
                    style: TextStyle(color: context.colorScheme.primary),
                  ),
                  const SizedBox(height: 25),

                  ValidatedTextField(
                    controller: nameController,
                    hintText: "Full Name",
                    obscureText: false,
                    validator:
                        (val) =>
                            val == null || val.isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 10),

                  ValidatedTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Enter email';
                      if (!val.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  ValidatedTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                    validator:
                        (val) =>
                            val != null && val.length < 6
                                ? 'Min 6 characters'
                                : null,
                  ),
                  const SizedBox(height: 10),

                  ValidatedTextField(
                    controller: confirmController,
                    hintText: "Confirm Password",
                    obscureText: true,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Confirm your password';
                      }
                      if (val.length < 6) {
                        return 'Min 6 characters';
                      }
                      if (val != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  MyButton(onTap: _submit, text: "Register"),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a member?",
                        style: TextStyle(color: context.colorScheme.primary),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: context.colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
