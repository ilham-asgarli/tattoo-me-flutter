import 'package:tattoo/backend/features/auth/interfaces/backend_auth_interface.dart';

import '../../../../domain/models/auth/user_model.dart';

abstract class BackendAnonymousAuthInterface extends BackendAuthInterface {
  Future<void> signInAnonymously(UserModel userModel);
}
