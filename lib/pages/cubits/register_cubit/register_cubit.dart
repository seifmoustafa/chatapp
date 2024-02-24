import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> registerUser(
      {required String email,
      required String password,
      required String userName}) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      saveUser(email: email, userName: userName);
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(errMessage: 'Email already on use'));
      } else if (e.code == 'weak-password') {
        emit(RegisterFailure(errMessage: 'Weak password'));
      }
    } catch (ex) {
      emit(RegisterFailure(errMessage: 'Something wrong'));
    }
  }

  void saveUser({required String email, required String userName}) {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(
      kUserNameCollections,
    );
    collectionReference.doc(email).set({
      kUserName: userName,
      kEmail: email,
    });
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
