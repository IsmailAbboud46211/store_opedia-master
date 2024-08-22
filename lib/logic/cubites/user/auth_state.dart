abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthProgress extends AuthState {}

class UserLoginedIn extends AuthState {}

class OwnerLoginedIn extends AuthState {}

class OwnerWillSelectStore extends AuthState {}

class UserSignedUp extends AuthState {}

class OwnerSignedUp extends AuthState {}

class AuthFailed extends AuthState {
  final String message;
  AuthFailed(this.message);
}

class NoAuthentication extends AuthState {}
