import '../../../core/base/models/base_model.dart';

import '../design-request/design_request_model.dart';

class DesignResponseModel extends BaseModel<DesignResponseModel> {
  String? id;
  String? requestId;
  String? designerId;
  String? imageLink;
  num? rating;
  bool? deleted;
  DateTime? createdDate;
  DesignRequestModel? designRequestModel;

  DesignResponseModel({
    this.id,
    this.requestId,
    this.designerId,
    this.imageLink,
    this.rating,
    this.deleted,
    this.createdDate,
    this.designRequestModel,
  });

  @override
  DesignResponseModel fromJson(Map<String, dynamic> json) {
    return DesignResponseModel(
      id: json["id"],
      requestId: json["requestId"],
      designerId: json["designerId"],
      imageLink: json["imageLink"],
      rating: json["rating"],
      deleted: json["deleted"],
      createdDate: json["createdDate"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "requestId": requestId,
      "designerId": designerId,
      "imageLink": imageLink,
      "rating": rating,
      "deleted": deleted,
      "createdDate": createdDate,
    };
  }
}
