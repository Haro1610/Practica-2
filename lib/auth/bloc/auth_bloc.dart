import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practica_2/auth/user_auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserAuthRepository _authRepo = UserAuthRepository();

  AuthBloc() : super(AuthInitial()) {
    on<VerifyAuthEvent>(_authVerification);
    on<AnonymousAuthEvent>(_authAnonymous);
    on<GoogleAuthEvent>(_authUser);
    on<SingOutEvent>(_singOut);
  }

  FutureOr<void> _authVerification(event, emit) {
    // inicializar los datos de la app
    if (_authRepo.isAlreadyAuthenticated()) {
      emit(AuthSuccesState());
    } else {
      emit(AuthErrorState());
    }
  }

  FutureOr<void> _singOut(event, emit) async {
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      await _authRepo.singOutFirebaseUsers();
    } else {
      await _authRepo.singOutFirebaseUsers();
      await _authRepo.singOutGoogleUsers();
    }
    emit(SingOutSucces());
  }

  FutureOr<void> _authUser(event, emit) async {
    emit(AuthAwaitingState());
    try {
      await _authRepo.singInGoogle();
      emit(AuthSuccesState());
    } catch (e) {
      print("Error al autenticar: $e");
      emit(AuthErrorState());
    }
    // if (FirebaseAuth.instance.currentUser!.isAnonymous) {
    //   await _authRepo.singOutFirebaseUsers();
    // } else {
    //   await _authRepo.singOutFirebaseUsers();
    //   await _authRepo.singOutGoogleUsers();
    // }
  }

  FutureOr<void> _authAnonymous(event, emit) {}
}
