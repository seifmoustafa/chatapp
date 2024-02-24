import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/helper/show_snakbar.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/pages/cubits/chat_cubit/chat_cubit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:chat_app/pages/cubits/register_cubit/register_cubit.dart';

class RegisterPage extends StatelessWidget {
  static String id = 'RegisterPage';
  String? email;
  String? userName;
  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessages();
          Navigator.pushNamed(context, ChatPage.id, arguments: {
            'email': email,
            'username': BlocProvider.of<RegisterCubit>(context)
                .getUsername(email)
                .toString()
          });
          isLoading = false;
        } else if (state is RegisterFailure) {
          showSnackBar(context, message: state.errMessage);
          isLoading = false;
        }
      },
      builder: (context, state) {
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
                          BlocProvider.of<RegisterCubit>(context).registerUser(
                            email: email!,
                            password: password!,
                            userName: userName!,
                          );
                          BlocProvider.of<ChatCubit>(context).getMessages();

                          // Navigator.pushNamed(context, ChatPage.id, arguments: {
                          //   'email': email,
                          //   'username': BlocProvider.of<RegisterCubit>(context)
                          //       .getUsername(email)
                          //       .toString(),
                          // });
                        }
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
      },
    );
  }
}
