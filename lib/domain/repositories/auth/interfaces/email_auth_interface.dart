import '../../../../core/network/interfaces/response_model.dart';
import '../../../models/auth/user_model.dart';

abstract class EmailAuthInterface {
  Future<IResponseModel<void>> signUpWithEmailAndPassword(UserModel userModel);
  Future<IResponseModel<void>> signInWithEmailAndPassword(UserModel userModel);
}
