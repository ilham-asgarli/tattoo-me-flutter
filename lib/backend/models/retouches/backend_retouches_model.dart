import 'package:tattoo/core/base/models/base_model.dart';
import 'package:tattoo/core/extensions/map_extension.dart';

class BackendRetouchesModel extends BaseModel<BackendRetouchesModel> {
  String? id;
  String? userId;
  String? designId;
  String? comment;

  BackendRetouchesModel({
    this.id,
    this.userId,
    this.designId,
    this.comment,
  });

  @override
  BackendRetouchesModel fromJson(Map<String, dynamic> json) {
    return BackendRetouchesModel(
      id: json["id"],
      userId: json["userId"],
      designId: json["designId"],
      comment: json["comment"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.putIfNotNull("userId", userId);
    map.putIfNotNull("designId", designId);
    map.putIfNotNull("comment", comment);

    return map;
  }
}
