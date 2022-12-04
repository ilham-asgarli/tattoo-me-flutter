import 'package:tattoo/core/base/models/base_model.dart';

class DesignRequestImageModel extends BaseModel<DesignRequestImageModel> {
  String? name;
  dynamic image;

  DesignRequestImageModel({
    required this.name,
    required this.image,
  });

  @override
  DesignRequestImageModel fromJson(Map<String, dynamic> json) {
    return DesignRequestImageModel(
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
