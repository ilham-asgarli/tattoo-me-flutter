import '../../../core/base/models/base_model.dart';

class DesignRequestImageModel2 extends BaseModel<DesignRequestImageModel2> {
  String? id;
  String? requestId;
  String? link;
  String? name;

  DesignRequestImageModel2({
    this.id,
    this.requestId,
    this.link,
    this.name,
  });

  @override
  DesignRequestImageModel2 fromJson(Map<String, dynamic> json) {
    return DesignRequestImageModel2(
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
