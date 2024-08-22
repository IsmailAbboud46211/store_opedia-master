part of 'contact_us_cubit.dart';

abstract class ContactUsState {}

class ContactUsInitial extends ContactUsState {}

class ContactUsProgress extends ContactUsState {}

class ContactUsSucceed extends ContactUsState {}

class ContactUsFailed extends ContactUsState {
  String message;
  ContactUsFailed({required this.message});
}
