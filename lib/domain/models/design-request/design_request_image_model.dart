import 'package:tattoo/core/base/models/base_model.dart';

class DesignRequestImageModel extends BaseModel<DesignRequestImageModel> {
  String? id;
  String? requestId;
  String? link;

  DesignRequestImageModel({
    this.id,
    this.requestId,
    this.link,
  });

  @override
  DesignRequestImageModel fromJson(Map<String, dynamic> json) {
    return DesignRequestImageModel(
      id: json["id"],
      requestId: json["requestId"],
      link: json["link"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "requestId": requestId,
      "link": link,
    };
  }
}
