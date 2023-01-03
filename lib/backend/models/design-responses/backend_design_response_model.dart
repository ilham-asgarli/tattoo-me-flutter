import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/core/base/models/base_model.dart';
import 'package:tattoo/core/extensions/map_extension.dart';
import 'package:tattoo/domain/models/design-response/design_response_model.dart';

class BackendDesignResponseModel extends BaseModel<BackendDesignResponseModel> {
  String? id;
  String? requestId;
  String? designerId;
  String? imageLink;
  num? rating;
  bool? deleted;
  Timestamp? createdDate;

  BackendDesignResponseModel({
    this.id,
    this.requestId,
    this.designerId,
    this.imageLink,
    this.rating,
    this.deleted,
    this.createdDate,
  });

  BackendDesignResponseModel.from({required DesignResponseModel model}) {
    id = model.id;
    requestId = model.requestId;
    designerId = model.designerId;
    imageLink = model.imageLink;
    rating = model.rating;
    deleted = model.deleted;
    createdDate = model.createdDate != null
        ? Timestamp.fromDate(model.createdDate!)
        : null;
  }

  DesignResponseModel to({required BackendDesignResponseModel model}) {
    return DesignResponseModel(
      id: model.id,
      requestId: model.requestId,
      designerId: model.designerId,
      imageLink: model.imageLink,
      rating: model.rating,
      deleted: model.deleted,
      createdDate:
          model.createdDate is Timestamp ? model.createdDate?.toDate() : null,
    );
  }

  @override
  BackendDesignResponseModel fromJson(Map<String, dynamic> json) {
    return BackendDesignResponseModel(
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
    Map<String, dynamic> map = {};

    map.putIfNotNull("requestId", designerId);
    map.putIfNotNull("designerId", designerId);
    map.putIfNotNull("imageLink", imageLink);
    map.putIfNotNull("rating", rating);
    map.putIfNotNull("deleted", deleted);
    map.putIfNotNull("createdDate", createdDate);

    return map;
  }
}
