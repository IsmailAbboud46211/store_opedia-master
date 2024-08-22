part of 'verify_password_cubit.dart';

abstract class VerifyPasswordState {}

class VerifyPasswordInitial extends VerifyPasswordState {}

class VerifyPasswordProgress extends VerifyPasswordState {}

class VerifyPasswordSucceed extends VerifyPasswordState {}

class VerifyPasswordFailed extends VerifyPasswordState {
  String message;
  VerifyPasswordFailed({required this.message});
}
