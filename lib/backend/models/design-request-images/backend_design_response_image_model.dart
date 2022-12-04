import 'package:tattoo/core/base/models/base_model.dart';

import '../../../domain/models/design-request/design_response_image_model.dart';

class BackendDesignResponseImageModel
    extends BaseModel<BackendDesignResponseImageModel> {
  String? id;
  String? requestId;
  String? link;

  BackendDesignResponseImageModel({
    this.id,
    this.requestId,
    this.link,
  });

  BackendDesignResponseImageModel.from(
      {required DesignResponseImageModel model}) {
    id = model.id;
    requestId = model.requestId;
    link = model.link;
  }

  DesignResponseImageModel to(
      {required BackendDesignResponseImageModel model}) {
    return DesignResponseImageModel(
      id: model.id,
      requestId: model.requestId,
      link: model.link,
    );
  }

  @override
  BackendDesignResponseImageModel fromJson(Map<String, dynamic> json) {
    return BackendDesignResponseImageModel(
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
