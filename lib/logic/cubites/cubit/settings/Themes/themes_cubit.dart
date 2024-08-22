import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'dart:convert';

import 'package:shopesapp/main.dart';

part 'themes_state.dart';

class ThemesCubit extends Cubit<ThemesState> with HydratedMixin {
  ThemesCubit() : super(const ThemesState(themeIndex: 0));

  int _index = 0;
  void getStoredTheme() async {}
  void changeTheme(int index) {
    _index = index;
    if (index == 2) {
      globalSharedPreference.setBool("isDarkMode", true);
    } else {
      globalSharedPreference.setBool("isDarkMode", false);
    }
    emit(ThemesState(themeIndex: index));
  }

  int getTheme() => _index;
  @override
  ThemesState? fromJson(Map<String, dynamic> json) {
    return ThemesState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(ThemesState state) {
    return state.toMap();
  }
}
