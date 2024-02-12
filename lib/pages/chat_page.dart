import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChatPage extends StatelessWidget {
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessageCollections);
  CollectionReference userData =
      FirebaseFirestore.instance.collection(kUserNameCollections);

  TextEditingController controller = TextEditingController();
  static String id = 'ChatPage';
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    late String emailP;
    late String userName;
    Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    emailP = args!['email'];
    userName = args['username'];

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreateTime, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(
              Message.fromJson(
                snapshot.data!.docs[i],
              ),
            );
          }
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
                  child: ListView.builder(
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (data) {
                      _sendMessage(emailP, userName);
                    },
                    decoration: InputDecoration(
                      hintText: 'Send Message',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _sendMessage(emailP, userName);
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
        } else {
          return ModalProgressHUD(inAsyncCall: true, child: Scaffold());
        }
      },
    );
  }

  void addMessages(String emailP, String data, String userName) {
    messages.add({
      kId: emailP,
      kMessage: data,
      kCreateTime: DateTime.now(),
      kUserName: userName,
    });
  }

  void _sendMessage(String emailP, String userName) {
    addMessages(emailP, controller.text, userName);
    controller.clear();
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
    );
  }
}

Stream<DocumentSnapshot> getDocumentStream(String documentId) {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('your_collection');
  return collectionReference.doc(documentId).snapshots();
}
