import 'package:firebase_auth/firebase_auth.dart';
import 'package:tattoo/backend/features/auth/interfaces/backend_auth_interface.dart';

class BackendAuthImplementation extends BackendAuthInterface {
  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> linkWithCredential(AuthCredential authCredential) async {
    try {
      final credential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(authCredential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          break;
        case "invalid-credential":
          break;
        case "credential-already-in-use":
          break;
        default:
      }
    } catch (e) {}
  }
}
