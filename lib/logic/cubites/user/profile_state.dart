part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ShowProfile extends ProfileState {}

class EditProfile extends ProfileState {}
