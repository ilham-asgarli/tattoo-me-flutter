import 'package:firebase_auth/firebase_auth.dart';

abstract class BackendAuthInterface {
  Future<void> signOut();

  Future<void> linkWithCredential(AuthCredential authCredential);
}
