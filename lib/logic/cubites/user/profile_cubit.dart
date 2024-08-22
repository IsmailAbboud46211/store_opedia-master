// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  late bool verified;
  void initVerified() {
    verified = false;
  }

  void checkPassword(bool verified) {
    if (verified) {
      emit(EditProfile());
    } else {
      emit(ShowProfile());
    }
  }

  void setVerifiy(bool value) {
    verified = value;
    checkPassword(verified);
  }
}
