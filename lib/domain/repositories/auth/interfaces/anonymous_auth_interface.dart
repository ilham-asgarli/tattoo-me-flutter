import 'package:tattoo/core/network/interfaces/response_model.dart';

import '../../../models/auth/user_model.dart';

abstract class AnonymousAuthInterface {
  Future<IResponseModel<void>> signInAnonymously(UserModel userModel);
}
