// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'internet_cubit.dart';

@immutable
abstract class InternetState {}

class InternetLoading extends InternetState {}

class InternetConnected extends InternetState {
  final ConnectionType connectionType;

  InternetConnected({
    required this.connectionType,
  });
}

class InternetDisconnected extends InternetState {
  InternetDisconnected();
}
