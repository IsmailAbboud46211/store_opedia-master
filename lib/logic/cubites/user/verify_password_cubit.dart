import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shopesapp/data/repositories/auth_repository.dart';
import 'package:shopesapp/main.dart';

import '../../../translation/locale_keys.g.dart';

part 'verify_password_state.dart';

class VerifyPasswordCubit extends Cubit<VerifyPasswordState> {
  VerifyPasswordCubit() : super(VerifyPasswordInitial());

  Future verifyPassword({required String password}) async {
    emit(VerifyPasswordProgress());

    String? id = globalSharedPreference.getString("ID")!;

    String? response =
        await AuthRepository().verifyPassword(password: password, id: id);

    if (response == null) {
      emit(VerifyPasswordFailed(
          message: LocaleKeys.failed_verify_password.tr()));
    } else if (response == "MisMatched") {
      emit(VerifyPasswordFailed(message: LocaleKeys.misMatched.tr()));
    } else {
      emit(VerifyPasswordSucceed());
    }
  }
}
