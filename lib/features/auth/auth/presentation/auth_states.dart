import 'package:myapp/features/auth/auth/domain/AppUser.dart';

abstract class AuthStates {}

class Authenticated extends AuthStates {
  AppUser user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthStates {}

class AuthLoading extends AuthStates {}

class AuthError extends AuthStates {
  String message;
  AuthError(this.message);
}
