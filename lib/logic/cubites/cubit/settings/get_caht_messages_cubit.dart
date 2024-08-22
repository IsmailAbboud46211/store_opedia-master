// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shopesapp/data/repositories/user_repository.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

part 'get_caht_messages_state.dart';

class GetCahtMessagesCubit extends Cubit<GetCahtMessagesState> {
  GetCahtMessagesCubit() : super(GetCahtMessagesInitial());
  List<dynamic> messages = [];
  void setMessages(var messagesResponse) {
    messages = messagesResponse;
  }

  List<dynamic> getMessages() => messages;

  Future getChatMessages({required String ownerID}) async {
    emit(GetCahtMessagesProgress());
    var response = await UserRepository().getCahtMessages(userID: ownerID);

    if (response == null || response["message"] != "Done") {
      emit(GetCahtMessagesFailed(
          message: response == null
              ? LocaleKeys.get_messages_failed.tr()
              : response["message"]));
    } else {
      messages = response["inbox"];
      setMessages(response["inbox"]);
      emit(GetCahtMessagesSucceed());
    }
  }
}
