import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/base/models/base_model.dart';
import '../../../core/extensions/map_extension.dart';
import '../../../domain/models/auth/user_model.dart';
import '../../core/encrypt/core_encrypt.dart';

class BackendUserModel extends BaseModel<BackendUserModel> {
  String? id;
  String? email;
  String? password;
  bool? isFirstOrderInsufficientBalance;
  bool? isBoughtFirstDesign;
  dynamic balance;
  dynamic createdDate;
  dynamic lastAppEntryDate;

  BackendUserModel({
    this.id,
    this.email,
    this.password,
    this.balance,
    this.isFirstOrderInsufficientBalance,
    this.isBoughtFirstDesign,
    this.createdDate,
    this.lastAppEntryDate,
  });

  BackendUserModel.from({required UserModel userModel}) {
    id = userModel.id;
    email = userModel.email;
    password = userModel.password != null
        ? CoreEncrypt().cryptFile(userModel.password!)
        : null;
    balance = userModel.balance;
    isFirstOrderInsufficientBalance = userModel.isFirstOrderInsufficientBalance;
    isBoughtFirstDesign = userModel.isBoughtFirstDesign;
    createdDate = userModel.createdDate != null
        ? Timestamp.fromDate(userModel.createdDate!)
        : null;
    lastAppEntryDate = userModel.lastAppEntryDate != null
        ? Timestamp.fromDate(userModel.lastAppEntryDate!)
        : null;
  }

  UserModel to({required BackendUserModel userModel}) {
    return UserModel(
      id: userModel.id,
      email: userModel.email,
      password: userModel.password,
      balance: userModel.balance,
      isFirstOrderInsufficientBalance:
          userModel.isFirstOrderInsufficientBalance,
      isBoughtFirstDesign: userModel.isBoughtFirstDesign,
      createdDate: userModel.createdDate is Timestamp
          ? userModel.createdDate?.toDate()
          : null,
      lastAppEntryDate: userModel.lastAppEntryDate is Timestamp
          ? userModel.lastAppEntryDate?.toDate()
          : null,
    );
  }

  @override
  BackendUserModel fromJson(Map<String, dynamic> json) {
    return BackendUserModel(
      id: json["id"],
      email: json["email"],
      password: json["password"],
      balance: json["balance"],
      isFirstOrderInsufficientBalance: json["isFirstOrderInsufficientBalance"],
      isBoughtFirstDesign: json["isBoughtFirstDesign"],
      createdDate: json["createdDate"],
      lastAppEntryDate: json["lastAppEntryDate"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.putIfNotNull("email", email);
    map.putIfNotNull("password", password);
    map.putIfNotNull("balance", balance);
    map.putIfNotNull(
        "isFirstOrderInsufficientBalance", isFirstOrderInsufficientBalance);
    map.putIfNotNull("isBoughtFirstDesign", isBoughtFirstDesign);
    map.putIfNotNull("createdDate", createdDate);
    map.putIfNotNull("lastAppEntryDate", lastAppEntryDate);

    return map;
  }
}
