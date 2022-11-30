import 'package:tattoo/domain/models/auth/user_model.dart';

import '../../../../core/base/models/base_response.dart';

abstract class EmailAuthInterface {
  Future<BaseResponse> signUpWithEmailAndPassword(UserModel userModel);
}
