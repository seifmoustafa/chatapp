import 'package:chat_app/constants.dart';

class Message {
  final String message;
  final String id;
  final String userName;
  Message(this.message, this.id, this.userName);

  factory Message.fromJson(jsonData) {
    return Message(
      jsonData[kMessage],
      jsonData[kId],
      jsonData[kUserName],
    );
  }
}
