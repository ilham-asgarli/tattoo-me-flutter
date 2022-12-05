import 'package:tattoo/core/base/models/base_model.dart';
import 'package:tattoo/core/extensions/map_extension.dart';

import '../../../domain/models/design-request/design_response_image_model.dart';

class BackendDesignResponseImageModel
    extends BaseModel<BackendDesignResponseImageModel> {
  String? id;
  String? requestId;
  String? link;
  String? name;

  BackendDesignResponseImageModel({
    this.id,
    this.requestId,
    this.link,
    this.name,
  });

  BackendDesignResponseImageModel.from(
      {required DesignResponseImageModel model}) {
    id = model.id;
    requestId = model.requestId;
    link = model.link;
    name = model.name;
  }

  DesignResponseImageModel to(
      {required BackendDesignResponseImageModel model}) {
    return DesignResponseImageModel(
      id: model.id,
      requestId: model.requestId,
      link: model.link,
      name: model.name,
    );
  }

  @override
  BackendDesignResponseImageModel fromJson(Map<String, dynamic> json) {
    return BackendDesignResponseImageModel(
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
