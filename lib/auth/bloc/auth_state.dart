part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthSuccesState extends AuthState {}

class AuthErrorState extends AuthState {}

class SingOutSucces extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthAwaitingState extends AuthState {}
