part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class VerifyAuthEvent extends AuthEvent {}

class GoogleAuthEvent extends AuthEvent {}

class AnonymousAuthEvent extends AuthEvent {}

class SingOutEvent extends AuthEvent {}
