import 'package:tattoo/core/network/interfaces/response_model.dart';
import 'package:tattoo/domain/repositories/auth/interfaces/auth_interface.dart';

import '../../../../backend/features/auth/implementations/backend_auth_implementations.dart';
import '../../../../core/network/models/response_model.dart';

class AuthImplementation extends AuthInterface {
  final BackendAuthImplementation auth = BackendAuthImplementation();

  @override
  Future<IResponseModel<void>> signOut() async {
    auth.signOut();
    return ResponseModel();
  }
}
