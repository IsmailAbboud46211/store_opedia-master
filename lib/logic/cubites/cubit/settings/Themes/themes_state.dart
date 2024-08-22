// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'themes_cubit.dart';

@immutable
class ThemesState {
  final int themeIndex;

  const ThemesState({required this.themeIndex});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'themeIndex': themeIndex,
    };
  }

  factory ThemesState.fromMap(Map<String, dynamic> map) {
    return ThemesState(
      themeIndex: map['themeIndex'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ThemesState.fromJson(String source) =>
      ThemesState.fromMap(json.decode(source) as Map<String, dynamic>);
}
