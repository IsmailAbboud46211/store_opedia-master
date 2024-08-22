String translateTimetoEnglish(String time) {
  List temp = time.split(" ");
  String str = temp[0];
  str += " ";
  str += temp[1] == "ص" ? "AM" : "PM";
  return str;
}

String translateTimetoArabic(String time) {
  List temp = time.split(" ");
  String str = temp[0];
  str += " ";
  str += temp[1] == "AM" ? "ص" : "م";
  return str;
}
