import 'package:chat_app/constants.dart';

class Email {
  final String email;

  final String username;
  Email(this.email, this.username);

  factory Email.fromJson(jsonData) {
    return Email(jsonData[kEmail], jsonData[kUserName]);
  }
}
