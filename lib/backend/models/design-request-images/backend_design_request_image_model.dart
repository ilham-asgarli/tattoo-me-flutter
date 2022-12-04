import 'package:tattoo/core/base/models/base_model.dart';

import '../../../domain/models/design-request/design_request_image_model.dart';

class BackendDesignRequestImageModel
    extends BaseModel<BackendDesignRequestImageModel> {
  String? id;
  String? requestId;
  String? link;

  BackendDesignRequestImageModel({
    this.id,
    this.requestId,
    this.link,
  });

  BackendDesignRequestImageModel.from(
      {required DesignRequestImageModel model}) {
    id = model.id;
    requestId = model.requestId;
    link = model.link;
  }

  DesignRequestImageModel to({required BackendDesignRequestImageModel model}) {
    return DesignRequestImageModel(
      id: model.id,
      requestId: model.requestId,
      link: model.link,
    );
  }

  @override
  BackendDesignRequestImageModel fromJson(Map<String, dynamic> json) {
    return BackendDesignRequestImageModel(
      id: json["id"],
      requestId: json["requestId"],
      link: json["link"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "requestId": requestId,
      "link": link,
    };
  }
}
