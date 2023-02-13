import 'package:tattoo/core/base/models/base_error.dart';

class UserNotFoundError<T> extends BaseError<T> {
  UserNotFoundError({super.message});
}