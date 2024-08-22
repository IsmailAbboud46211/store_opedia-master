part of 'get_caht_messages_cubit.dart';

abstract class GetCahtMessagesState {}

class GetCahtMessagesInitial extends GetCahtMessagesState {}

class GetCahtMessagesProgress extends GetCahtMessagesState {}

class GetCahtMessagesSucceed extends GetCahtMessagesState {}

class GetCahtMessagesFailed extends GetCahtMessagesState {
  String message;
  GetCahtMessagesFailed({required this.message});
}
