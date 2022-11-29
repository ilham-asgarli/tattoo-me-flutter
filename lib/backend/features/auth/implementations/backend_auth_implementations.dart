import 'package:firebase_auth/firebase_auth.dart';
import 'package:tattoo/backend/features/auth/interfaces/backend_auth_interface.dart';

class BackendAuthImplementation extends BackendAuthInterface {
  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
