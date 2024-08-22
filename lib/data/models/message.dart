// ignore_for_file: non_constant_identifier_names

class Message {
  final String description;
  final String type;
  final String? photo;
  final String creation_date;
  final String reply;
  final String reply_date;
  Message({
    required this.description,
    required this.reply,
    required this.reply_date,
    required this.creation_date,
    this.photo,
    required this.type,
  });
}
