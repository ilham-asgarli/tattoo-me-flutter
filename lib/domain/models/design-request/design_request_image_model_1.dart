import 'package:tattoo/core/base/models/base_model.dart';

class DesignRequestImageModel1 extends BaseModel<DesignRequestImageModel1> {
  String? name;
  dynamic image;

  DesignRequestImageModel1({
    required this.name,
    required this.image,
  });

  @override
  DesignRequestImageModel1 fromJson(Map<String, dynamic> json) {
    return DesignRequestImageModel1(
      name: json["name"],
      image: json["image"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "image": image,
    };
  }
}
