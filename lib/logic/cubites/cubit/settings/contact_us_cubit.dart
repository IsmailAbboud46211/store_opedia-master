// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../data/repositories/user_repository.dart';
import '../../../../translation/locale_keys.g.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit() : super(ContactUsInitial());

  Future contactUS({
    required String id,
    required String type,
    required String description,
    required String? photo,
    required String? imageType,
  }) async {
    emit(ContactUsProgress());

    String? response = await UserRepository().contactUS(
      id: id,
      type: type,
      description: description,
      photo: photo,
      imageType: imageType,
    );

    if (response == "Failed") {
      emit(ContactUsFailed(message: LocaleKeys.failed_to_contact_with_Us.tr()));
    } else {
      emit(ContactUsSucceed());
    }
  }
}
