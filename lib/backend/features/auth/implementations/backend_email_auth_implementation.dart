import 'package:firebase_auth/firebase_auth.dart';
import 'package:tattoo/backend/features/auth/interfaces/backend_email_auth_interface.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';

import 'backend_auth_implementations.dart';

class BackendEmailAuthImplementation extends BackendEmailAuthInterface {
  final BackendAuthImplementation auth = BackendAuthImplementation();

  @override
  Future<void> signUpWithEmailAndPassword(UserModel userModel) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          break;
        case 'email-already-in-use':
          break;
      }
    } catch (e) {}
  }

  @override
  Future<void> signInWithEmailAndPassword(UserModel userModel) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          break;
        case 'wrong-password':
          break;
      }
    } catch (e) {}
  }

  @override
  AuthCredential getCredential(UserModel userModel) {
    return EmailAuthProvider.credential(
      email: userModel.email,
      password: userModel.password,
    );
  }

  @override
  Future<void> linkWithEmailAndPassword(UserModel userModel) async {
    AuthCredential authCredential = getCredential(userModel);
    await auth.linkWithCredential(authCredential);
  }
}
