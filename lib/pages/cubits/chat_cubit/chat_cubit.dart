import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessageCollections);
  CollectionReference userData =
      FirebaseFirestore.instance.collection(kUserNameCollections);
  final _controller = ScrollController();
  TextEditingController controller = TextEditingController();

  void _addMessages(String emailP, String message, String userName) {
    try {
      messages.add({
        kId: emailP,
        kMessage: message,
        kCreateTime: DateTime.now(),
        kUserName: userName,
      });
    } on Exception catch (e) {
      // TODO
    }
  }

  void sendMessage(String emailP, String data, String userName) {
    _addMessages(emailP, data, userName);
    controller.clear();
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
    );
  }

  void getMessages() {
    messages.orderBy(kCreateTime, descending: true).snapshots().listen((event) {
      List<Message> messagesList = [];

      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc));
      }
      emit(ChatSuccess(messages: messagesList));
    });
  }
}
