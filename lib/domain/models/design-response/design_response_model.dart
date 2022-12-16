import 'package:tattoo/core/base/models/base_model.dart';

import '../design-request/design_request_model.dart';

class DesignResponseModel extends BaseModel<DesignResponseModel> {
  String? id;
  String? designerId;
  String? imageLink;
  num? rating;
  bool? deleted;
  DateTime? createdDate;
  DesignRequestModel? designRequestModel;

  DesignResponseModel({
    this.id,
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
      "designerId": designerId,
      "imageLink": imageLink,
      "rating": rating,
      "deleted": deleted,
      "createdDate": createdDate,
    };
  }
}
