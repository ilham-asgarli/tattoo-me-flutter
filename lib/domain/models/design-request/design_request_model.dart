import '../../../core/base/models/base_model.dart';

import 'design_request_image_model_1.dart';
import 'design_request_image_model_2.dart';

class DesignRequestModel extends BaseModel<DesignRequestModel> {
  String? id;
  String? userId;
  String? designerId;
  String? previousRequestId;
  String? retouchId;
  bool? finished;
  DateTime? createdDate;
  DateTime? startDesignDate;
  List<DesignRequestImageModel1>? designRequestImageModels1;
  List<DesignRequestImageModel2>? designRequestImageModels2;

  DesignRequestModel({
    this.id,
    this.userId,
    this.designerId,
    this.previousRequestId,
    this.retouchId,
    this.finished,
    this.createdDate,
    this.startDesignDate,
    this.designRequestImageModels1,
    this.designRequestImageModels2,
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
      startDesignDate: json["startDesignDate"],
      designRequestImageModels1: json["designRequestImageModels"],
      designRequestImageModels2: json["designResponseImageModels"],
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
      "startDesignDate": startDesignDate,
      "designRequestImageModels": designRequestImageModels1,
      "designResponseImageModels": designRequestImageModels2,
    };
  }
}
