import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:chat_app/pages/cubits/chat_cubit/chat_cubit.dart';

class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';
  String? message;
  @override
  Widget build(BuildContext context) {
    late String emailP;
    late String userName;
    Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    List<Message> messagesList = [];
    final _controller = ScrollController();
    TextEditingController controller = TextEditingController();
    emailP = args!['email'];
    userName = args['username'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kLogo,
              height: 50,
            ),
            const Text(
              'Chat',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatSuccess) {
                  messagesList = state.messages;
                }
              },
              builder: (context, state) {
                return ListView.builder(
                  reverse: true,
                  controller: _controller,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    return messagesList[index].id == emailP
                        ? ChatBuble(
                            message: messagesList[index],
                          )
                        : ChatBubleForFriend(
                            message: messagesList[index],
                          );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                message = value;
              },
              controller: controller,
              onSubmitted: (data) {
                BlocProvider.of<ChatCubit>(context)
                    .sendMessage(emailP, data, userName);
                BlocProvider.of<ChatCubit>(context);
                message = '';
              },
              decoration: InputDecoration(
                hintText: 'Send Message',
                suffixIcon: GestureDetector(
                  onTap: () {
                    BlocProvider.of<ChatCubit>(context)
                        .sendMessage(emailP, message!, userName);
                    message = '';
                  },
                  child: const Icon(
                    Icons.send,
                    color: kPrimaryColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: kPrimaryColor,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: kPrimaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
