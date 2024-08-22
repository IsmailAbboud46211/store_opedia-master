// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'work_time_state.dart';

class WorkTimeCubit extends Cubit<WorkTimeState> {
  WorkTimeCubit() : super(WorkTimeState(isOpen: false));

  TimeOfDay timeConvert(String normTime) {
    int hour;
    int minute;
    String ampm = normTime.substring(normTime.length - 2);
    String result = normTime.substring(0, normTime.indexOf(' '));
    if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
      hour = int.parse(result.split(':')[0]);
      if (hour == 12) hour = 0;
      minute = int.parse(result.split(":")[1]);
    } else {
      hour = int.parse(result.split(':')[0]) - 12;
      if (hour <= 0) {
        hour = 24 + hour;
      }
      minute = int.parse(result.split(":")[1]);
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  void testOpenTime(
      {required String? openTime, required String? closeTime}) async {
    if (openTime != null && closeTime != null) {
      TimeOfDay startTime = timeConvert(openTime);

      TimeOfDay endTime = timeConvert(closeTime);

      DateTime now = DateTime.now();
      DateTime startDateTime = DateTime(
          now.year, now.month, now.day, startTime.hour, startTime.minute);

      DateTime endDateTime =
          DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
      if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
        emit(WorkTimeState(isOpen: true));
      } else {
        emit(WorkTimeState(isOpen: false));
      }
    } else {
      emit(WorkTimeState(isOpen: false));
    }
  }
}
