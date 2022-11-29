import 'package:tattoo/core/base/models/base_model.dart';

class UserModel extends BaseModel<UserModel> {
  String email;
  String password;

  UserModel({required this.email, required this.password});

  @override
  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json["email"],
      password: json["password"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
    };
  }
}
