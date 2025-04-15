part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignUpWithEmail extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignUpWithEmail({required this.name,required this.email, required this.password});

  @override
  List<Object?> get props => [name,email, password];
}

class SignInWithEmail extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmail({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignInWithGoogle extends AuthEvent {}

class SignOut extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
