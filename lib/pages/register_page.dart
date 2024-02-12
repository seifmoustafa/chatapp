import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/helper/show_snakbar.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String id = 'RegisterPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;
  String? userName;
  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: formkey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 75,
                ),
                Image.asset(
                  kLogo,
                  height: 100,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      kName,
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontFamily: 'pacifico',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 75,
                ),
                const Row(
                  children: [
                    Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomFormTextField(
                  onChanged: (data) {
                    userName = data;
                  },
                  hintText: 'User Name',
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomFormTextField(
                  onChanged: (data) {
                    email = data;
                  },
                  hintText: 'Email',
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomFormTextField(
                  obscureText: true,
                  onChanged: (data) {
                    password = data;
                  },
                  hintText: 'Password',
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  onTap: () async {
                    if (formkey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        // Register the user
                        UserCredential user = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email!, password: password!);

                        // Save user data to Firestore
                        CollectionReference collectionReference =
                            FirebaseFirestore.instance.collection(
                          kUserNameCollections,
                        );
                        collectionReference.doc(email).set({
                          kUserName: userName,
                          kEmail: email,
                        });

                        // Retrieve the username from Firestore
                        String? username = await getUsername(email);

                        // Navigate to ChatPage with email and username as arguments
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(
                          context,
                          ChatPage.id,
                          arguments: {'email': email, 'username': username},
                        );

                        setState(() {});
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'email-already-in-use') {
                          // ignore: use_build_context_synchronously
                          showSnackBar(context,
                              message: 'Email already exists');
                        } else if (e.code == 'weak-password') {
                          // ignore: use_build_context_synchronously
                          showSnackBar(context, message: 'Weak Password');
                        }
                      } catch (ex) {
                        // ignore: use_build_context_synchronously
                        showSnackBar(context, message: 'There was an error');
                      }
                      isLoading = false;
                      setState(() {});
                    } else {}
                  },
                  buttonName: 'Register',
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '  Login',
                        style: TextStyle(color: Color(0xffC5E8E6)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> getUsername(String? email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(kUserNameCollections)
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['username'] as String?;
      } else {
        return null;
      }
    } catch (error) {
      // print("Error getting username: $error");
      return null;
    }
  }
}
