import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meta/meta.dart';
import 'package:shopesapp/data/repositories/user_repository.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

part 'delete_user_state.dart';

class DeleteUserCubit extends Cubit<DeleteUserState> {
  DeleteUserCubit() : super(DeleteUserInitial());

  Future deleteUser() async {
    emit(DeleteUserProgress());
    String id = globalSharedPreference.getString("ID")!;

    String response = await UserRepository().deleteUser(id: id);

    if (response == "Faield") {
      emit(DeleteUserFailed(message: LocaleKeys.delete_user_failed.tr()));
    } else if (response == "Success") {
      emit(DeleteUserSucceed());
    }
  }
}
