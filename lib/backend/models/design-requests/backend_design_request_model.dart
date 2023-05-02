import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/base/models/base_model.dart';
import '../../../core/extensions/map_extension.dart';
import '../../../domain/models/design-request/design_request_model.dart';
import 'backend_design_request_image_model.dart';

class BackendDesignRequestModel extends BaseModel<BackendDesignRequestModel> {
  String? id;
  String? userId;
  String? designerId;
  String? previousRequestId;
  String? retouchId;
  bool? finished;
  dynamic createdDate;
  dynamic startDesignDate;
  List<BackendDesignRequestImageModel>? designResponseImageModels;

  BackendDesignRequestModel({
    this.id,
    this.userId,
    this.designerId,
    this.previousRequestId,
    this.retouchId,
    this.finished,
    this.createdDate,
    this.startDesignDate,
    this.designResponseImageModels,
  });

  BackendDesignRequestModel.from({required DesignRequestModel model}) {
    id = model.id;
    userId = model.userId;
    designerId = model.designerId;
    previousRequestId = model.previousRequestId;
    retouchId = model.retouchId;
    finished = model.finished;
    createdDate = model.createdDate != null
        ? Timestamp.fromDate(model.createdDate!)
        : null;
    startDesignDate = model.startDesignDate != null
        ? Timestamp.fromDate(model.startDesignDate!)
        : null;
    designResponseImageModels = model.designRequestImageModels2
        ?.map((e) => BackendDesignRequestImageModel.from(model: e))
        .toList();
  }

  DesignRequestModel to({required BackendDesignRequestModel model}) {
    return DesignRequestModel(
      id: model.id,
      userId: model.userId,
      designerId: model.designerId,
      previousRequestId: model.previousRequestId,
      retouchId: model.retouchId,
      finished: model.finished,
      createdDate:
          model.createdDate is Timestamp ? model.createdDate?.toDate() : null,
      startDesignDate: model.createdDate is Timestamp
          ? model.startDesignDate?.toDate()
          : null,
      designRequestImageModels2: model.designResponseImageModels
          ?.map((e) => BackendDesignRequestImageModel().to(model: e))
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
      startDesignDate: json["startDesignDate"],
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
    map.putIfNotNull("startDesignDate", startDesignDate);

    return map;
  }
}
