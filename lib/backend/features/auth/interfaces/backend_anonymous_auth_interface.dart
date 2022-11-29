import '../../../../domain/models/auth/user_model.dart';

abstract class BackendAnonymousAuthInterface {
  Future<void> signInAnonymously(UserModel userModel);
}
