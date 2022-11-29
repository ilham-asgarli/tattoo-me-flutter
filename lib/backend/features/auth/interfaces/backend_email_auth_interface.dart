import '../../../../domain/models/auth/user_model.dart';

abstract class BackendEmailAuthInterface {
  Future<void> signUpWithEmailAndPassword(UserModel userModel);
  Future<void> signInWithEmailAndPassword(UserModel userModel);
}
