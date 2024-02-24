part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatSuccess extends ChatState {
  List<Message> messages;
  final ScrollController scrollController;
  TextEditingController textEditingController;
  ChatSuccess({
    required this.messages,
    required this.scrollController,
    required this.textEditingController,
  });
}
