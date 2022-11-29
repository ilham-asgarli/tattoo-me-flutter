import 'package:firebase_auth/firebase_auth.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';

import '../interfaces/backend_anonymous_auth_interface.dart';

class BackendAnonymousAuthImplementation extends BackendAnonymousAuthInterface {
  @override
  Future<void> signInAnonymously(UserModel userModel) async {
    try {
      final credential = await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          break;
        default:
      }
    } catch (e) {}
  }
}
