import 'package:tattoo/core/base/models/base_model.dart';

import 'design_request_image_model.dart';
import 'design_response_image_model.dart';

class DesignModel extends BaseModel<DesignModel> {
  String? id;
  String? userId;
  String? designerId;
  String? previousRequestId;
  String? retouchId;
  bool? finished;
  DateTime? createdDate;
  List<DesignRequestImageModel>? designRequestImageModels;
  List<DesignResponseImageModel>? designResponseImageModels;

  DesignModel({
    this.id,
    this.userId,
    this.designerId,
    this.previousRequestId,
    this.retouchId,
    this.finished,
    this.createdDate,
    this.designRequestImageModels,
    this.designResponseImageModels,
  });

  @override
  DesignModel fromJson(Map<String, dynamic> json) {
    return DesignModel(
      id: json["id"],
      userId: json["userId"],
      designerId: json["designerId"],
      previousRequestId: json["previousRequestId"],
      retouchId: json["retouchId"],
      finished: json["finished"],
      createdDate: json["createdDate"],
      designRequestImageModels: json["designRequestImageModels"],
      designResponseImageModels: json["designResponseImageModels"],
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
      "designResponseImageModels": designResponseImageModels,
    };
  }
}
