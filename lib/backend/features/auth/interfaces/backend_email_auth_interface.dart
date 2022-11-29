import 'package:firebase_auth/firebase_auth.dart';

import '../../../../domain/models/auth/user_model.dart';

abstract class BackendEmailAuthInterface {
  Future<void> signUpWithEmailAndPassword(UserModel userModel);

  Future<void> signInWithEmailAndPassword(UserModel userModel);

  AuthCredential getCredential(UserModel userModel);

  Future<void> linkWithEmailAndPassword(UserModel userModel);
}
