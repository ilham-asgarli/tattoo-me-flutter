import 'package:tattoo/core/base/models/base_model.dart';

import 'design_request_image_model.dart';

class DesignRequestModel extends BaseModel<DesignRequestModel> {
  String? id;
  String? userId;
  String? designerId;
  String? previousRequestId;
  String? retouchId;
  bool? finished;
  DateTime? createdDate;
  List<DesignRequestImageModel>? designRequestImageModels;

  DesignRequestModel({
    this.id,
    this.userId,
    this.designerId,
    this.previousRequestId,
    this.retouchId,
    this.finished,
    this.createdDate,
    this.designRequestImageModels,
  });

  @override
  DesignRequestModel fromJson(Map<String, dynamic> json) {
    return DesignRequestModel(
      id: json["id"],
      userId: json["userId"],
      designerId: json["designerId"],
      previousRequestId: json["previousRequestId"],
      retouchId: json["retouchId"],
      finished: json["finished"],
      createdDate: json["createdDate"],
      designRequestImageModels: json["designRequestImageModels"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "designerId": designerId,
      "previousRequestId": previousRequestId,
      "retouchId": retouchId,
      "finished": finished,
      "createdDate": createdDate,
      "designRequestImageModels": designRequestImageModels,
    };
  }
}
