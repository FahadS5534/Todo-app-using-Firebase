

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/auth/auth/data/FirebaseAuthRepo.dart';
import 'package:myapp/features/auth/auth/domain/AppUser.dart';
import 'package:myapp/features/auth/auth/presentation/auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final Firebaseauthrepo firebaseauthrepo;
  AppUser? _currentUser;
  AuthCubit(this.firebaseauthrepo) : super(AuthLoading());
  void check() async {
    final AppUser? appUser = await firebaseauthrepo.getCurrentUser();
    if (appUser != null) {
      _currentUser = appUser;
      emit(Authenticated(appUser));
    } else {
      emit(Unauthenticated());
    }
  
  }
    AppUser? get currentUser => _currentUser;
  Future<void> loginUserW(String email, String password) async {
      emit(AuthLoading());
      final AppUser? user = await  firebaseauthrepo.loginUser(email, password);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(AuthError("Login failed"));

      }
    }
    Future<void> SignUpUserW(String name,String email, String password) async {
      emit(AuthLoading());
      final AppUser? user = await  firebaseauthrepo.signUpUser(name,email, password);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(AuthError("Login failed"));

      }
    }
    Future<void> LogOut() async {
      await firebaseauthrepo.signOut();
      _currentUser = null;
      emit(Unauthenticated());
    }


}
