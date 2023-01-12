import 'base_response.dart';

class BaseError<T> extends BaseResponse<T> {
  String? code;

  BaseError({
    super.message,
    this.code,
  });
}
