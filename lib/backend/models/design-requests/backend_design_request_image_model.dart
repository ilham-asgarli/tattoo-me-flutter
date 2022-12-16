import 'package:tattoo/core/base/models/base_model.dart';
import 'package:tattoo/core/extensions/map_extension.dart';

import '../../../domain/models/design-request/design_request_image_model_2.dart';

class BackendDesignRequestImageModel
    extends BaseModel<BackendDesignRequestImageModel> {
  String? id;
  String? requestId;
  String? link;
  String? name;

  BackendDesignRequestImageModel({
    this.id,
    this.requestId,
    this.link,
    this.name,
  });

  BackendDesignRequestImageModel.from(
      {required DesignRequestImageModel2 model}) {
    id = model.id;
    requestId = model.requestId;
    link = model.link;
    name = model.name;
  }

  DesignRequestImageModel2 to({required BackendDesignRequestImageModel model}) {
    return DesignRequestImageModel2(
      id: model.id,
      requestId: model.requestId,
      link: model.link,
      name: model.name,
    );
  }

  @override
  BackendDesignRequestImageModel fromJson(Map<String, dynamic> json) {
    return BackendDesignRequestImageModel(
      id: json["id"],
      requestId: json["requestId"],
      link: json["link"],
      name: json["name"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.putIfNotNull("requestId", requestId);
    map.putIfNotNull("link", link);
    map.putIfNotNull("name", name);

    return map;
  }
}
