import 'package:tattoo/domain/repositories/auth/implementations/auth_repository.dart';
import 'package:tattoo/domain/repositories/auth/implementations/email_auth_repository.dart';
import 'package:tattoo/domain/usecases/auth/interfaces/email_auth_interface.dart';

class EmailAuthUseCase extends EmailAuthInterface {
  EmailAuthRepository emailAuthRepository = EmailAuthRepository();
  AuthRepository authRepository = AuthRepository();

  @override
  bool isSignedInWithVerifiedEmail() {
    return emailAuthRepository.emailVerified();
  }
}
