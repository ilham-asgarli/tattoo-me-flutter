import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/base/models/base_model.dart';
import '../../../core/extensions/map_extension.dart';
import '../../../domain/models/auth/user_model.dart';
import '../../core/encrypt/core_encrypt.dart';

class BackendUserModel extends BaseModel<BackendUserModel> {
  String? id;
  String? email;
  String? password;
  String? deviceToken;
  bool? isFirstOrderInsufficientBalance;
  bool? isBoughtFirstDesign;
  bool? isSpentCredit;
  dynamic balance;
  dynamic createdDate;
  dynamic lastAppEntryDate;

  BackendUserModel({
    this.id,
    this.email,
    this.password,
    this.deviceToken,
    this.balance,
    this.isFirstOrderInsufficientBalance,
    this.isBoughtFirstDesign,
    this.isSpentCredit,
    this.createdDate,
    this.lastAppEntryDate,
  });

  BackendUserModel.from({required UserModel userModel}) {
    id = userModel.id;
    email = userModel.email;
    password = userModel.password != null
        ? CoreEncrypt().cryptFile(userModel.password!)
        : null;
    deviceToken = userModel.deviceToken;
    balance = userModel.balance;
    isFirstOrderInsufficientBalance = userModel.isFirstOrderInsufficientBalance;
    isBoughtFirstDesign = userModel.isBoughtFirstDesign;
    isSpentCredit = userModel.isSpentCredit;
    createdDate = userModel.createdDate != null
        ? Timestamp.fromDate(userModel.createdDate!)
        : null;
    lastAppEntryDate = userModel.lastAppEntryDate != null
        ? Timestamp.fromDate(userModel.lastAppEntryDate!)
        : null;
  }

  UserModel to({required BackendUserModel userModel}) {
    num balance = userModel.balance ?? 0;

    return UserModel(
      id: userModel.id,
      email: userModel.email,
      password: userModel.password,
      deviceToken: userModel.deviceToken,
      balance: balance.toInt(),
      isFirstOrderInsufficientBalance:
          userModel.isFirstOrderInsufficientBalance,
      isBoughtFirstDesign: userModel.isBoughtFirstDesign,
      isSpentCredit: userModel.isSpentCredit,
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
      deviceToken: json["deviceToken"],
      balance: json["balance"],
      isFirstOrderInsufficientBalance: json["isFirstOrderInsufficientBalance"],
      isBoughtFirstDesign: json["isBoughtFirstDesign"],
      isSpentCredit: json["isSpentCredit"],
      createdDate: json["createdDate"],
      lastAppEntryDate: json["lastAppEntryDate"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.putIfNotNull("email", email);
    map.putIfNotNull("password", password);
    map.putIfNotNull("deviceToken", deviceToken);
    map.putIfNotNull("balance", balance);
    map.putIfNotNull(
        "isFirstOrderInsufficientBalance", isFirstOrderInsufficientBalance);
    map.putIfNotNull("isBoughtFirstDesign", isBoughtFirstDesign);
    map.putIfNotNull("isSpentCredit", isSpentCredit);
    map.putIfNotNull("createdDate", createdDate);
    map.putIfNotNull("lastAppEntryDate", lastAppEntryDate);

    return map;
  }
}
