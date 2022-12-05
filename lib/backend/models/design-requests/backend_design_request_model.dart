import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/core/base/models/base_model.dart';
import 'package:tattoo/core/extensions/map_extension.dart';
import 'package:tattoo/domain/models/design-request/design_model.dart';

import 'backend_design_request_image_model.dart';
import 'backend_design_response_image_model.dart';

class BackendDesignRequestModel extends BaseModel<BackendDesignRequestModel> {
  String? id;
  String? userId;
  String? designerId;
  String? previousRequestId;
  String? retouchId;
  bool? finished;
  Timestamp? createdDate;
  List<BackendDesignRequestImageModel>? designRequestImageModels;
  List<BackendDesignResponseImageModel>? designResponseImageModels;

  BackendDesignRequestModel({
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

  BackendDesignRequestModel.from({required DesignModel model}) {
    id = model.id;
    userId = model.userId;
    designerId = model.designerId;
    previousRequestId = model.previousRequestId;
    retouchId = model.retouchId;
    finished = model.finished;
    createdDate = model.createdDate != null
        ? Timestamp.fromDate(model.createdDate!)
        : null;
    designRequestImageModels = model.designRequestImageModels
        ?.map((e) => BackendDesignRequestImageModel.from(model: e))
        .toList();
    designResponseImageModels = model.designResponseImageModels
        ?.map((e) => BackendDesignResponseImageModel.from(model: e))
        .toList();
  }

  DesignModel to({required BackendDesignRequestModel model}) {
    return DesignModel(
      id: model.id,
      userId: model.userId,
      designerId: model.designerId,
      previousRequestId: model.previousRequestId,
      retouchId: model.retouchId,
      finished: model.finished,
      createdDate: model.createdDate != null ? createdDate?.toDate() : null,
      designRequestImageModels: model.designRequestImageModels
          ?.map((e) => BackendDesignRequestImageModel().to(model: e))
          .toList(),
      designResponseImageModels: model.designResponseImageModels
          ?.map((e) => BackendDesignResponseImageModel().to(model: e))
          .toList(),
    );
  }

  @override
  BackendDesignRequestModel fromJson(Map<String, dynamic> json) {
    return BackendDesignRequestModel(
      id: json["id"],
      userId: json["userId"],
      designerId: json["designerId"],
      previousRequestId: json["previousRequestId"],
      retouchId: json["retouchId"],
      finished: json["finished"],
      createdDate: json["createdDate"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.putIfNotNull("userId", userId);
    map.putIfNotNull("designerId", designerId);
    map.putIfNotNull("previousRequestId", previousRequestId);
    map.putIfNotNull("retouchId", retouchId);
    map.putIfNotNull("finished", finished);
    map.putIfNotNull("createdDate", createdDate);

    return map;
  }
}
