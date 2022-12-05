import 'package:tattoo/core/base/models/base_model.dart';

class DesignResponseImageModel extends BaseModel<DesignResponseImageModel> {
  String? id;
  String? requestId;
  String? link;
  String? name;

  DesignResponseImageModel({
    this.id,
    this.requestId,
    this.link,
    this.name,
  });

  @override
  DesignResponseImageModel fromJson(Map<String, dynamic> json) {
    return DesignResponseImageModel(
      id: json["id"],
      requestId: json["requestId"],
      link: json["link"],
      name: json["name"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "requestId": requestId,
      "link": link,
      "name": name,
    };
  }
}
