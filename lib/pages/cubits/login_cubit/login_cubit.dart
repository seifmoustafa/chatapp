import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/helper/show_snakbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure(errMessage: 'User not found'));
      } else if (e.code == 'auth/wrong-password') {
        emit(LoginFailure(errMessage: 'Wrong password'));
      } else {
        emit(LoginFailure(errMessage: 'Something wrong'));
      }
    } catch (e) {
      emit(LoginFailure(errMessage: 'Something wrong'));
    }
  }

   Future<String?> getUsername(String? email) async {
    CollectionReference userData =
      FirebaseFirestore.instance.collection(kUserNameCollections);
    try {
      QuerySnapshot querySnapshot =
          await userData.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['username'] as String?;
      } else {
        return null;
      }
    } catch (error) {
      print("Error getting username: $error");
      return null;
    }
  }
}
