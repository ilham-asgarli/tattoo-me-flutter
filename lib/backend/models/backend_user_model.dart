import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/core/base/models/base_model.dart';

import '../../domain/models/auth/user_model.dart';
import '../core/encrypt/core_encrypt.dart';

class BackendUserModel extends BaseModel<BackendUserModel> {
  String? id;
  String? email;
  String? password;
  int balance = 0;
  Timestamp? createdDate;
  Timestamp? lastAppEntryDate;

  BackendUserModel({
    this.id,
    this.email,
    this.password,
    this.balance = 0,
    this.createdDate,
    this.lastAppEntryDate,
  });

  BackendUserModel.fromUserModel({required UserModel userModel}) {
    id = userModel.id;
    email = userModel.email;
    password = CoreEncrypt().cryptFile(userModel.password ?? "");
    balance = userModel.balance ?? 0;
    createdDate = userModel.createdDate != null
        ? Timestamp.fromDate(userModel.createdDate!)
        : null;
    lastAppEntryDate = userModel.lastAppEntryDate != null
        ? Timestamp.fromDate(userModel.lastAppEntryDate!)
        : null;
  }

  UserModel toUserModel({required BackendUserModel userModel}) {
    return UserModel(
      id: userModel.id,
      email: userModel.email,
      password: userModel.password,
      balance: userModel.balance,
      createdDate: userModel.createdDate != null ? createdDate?.toDate() : null,
      lastAppEntryDate: userModel.lastAppEntryDate != null
          ? lastAppEntryDate?.toDate()
          : null,
    );
  }

  BackendUserModel.sign({required this.email, required this.password});

  @override
  BackendUserModel fromJson(Map<String, dynamic> json) {
    return BackendUserModel(
      id: json["id"],
      email: json["email"],
      password: json["password"],
      balance: json["balance"],
      createdDate: json["createdDate"],
      lastAppEntryDate: json["lastAppEntryDate"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "balance": balance,
      "createdDate": createdDate,
      "lastAppEntryDate": lastAppEntryDate,
    };
  }
}
