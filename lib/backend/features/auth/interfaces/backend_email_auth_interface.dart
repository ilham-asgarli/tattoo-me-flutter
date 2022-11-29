import 'package:tattoo/backend/features/auth/interfaces/backend_auth_interface.dart';

import '../../../../domain/models/auth/user_model.dart';

abstract class BackendEmailAuthInterface extends BackendAuthInterface {
  Future<void> signUpWithEmailAndPassword(UserModel userModel);
  Future<void> signInWithEmailAndPassword(UserModel userModel);
}
