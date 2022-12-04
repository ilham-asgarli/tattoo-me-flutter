import 'package:tattoo/core/base/models/base_model.dart';
import 'package:tattoo/domain/models/design-request/design_request_image_model.dart';

class BackendDesignRequestImageModel
    extends BaseModel<BackendDesignRequestImageModel> {
  String? name;
  dynamic image;

  BackendDesignRequestImageModel({
    this.name,
    this.image,
  });

  BackendDesignRequestImageModel.from(
      {required DesignRequestImageModel model}) {
    name = model.name;
    image = model.image;
  }

  DesignRequestImageModel to({required BackendDesignRequestImageModel model}) {
    return DesignRequestImageModel(
      name: model.name,
      image: model.image,
    );
  }

  @override
  BackendDesignRequestImageModel fromJson(Map<String, dynamic> json) {
    return BackendDesignRequestImageModel(
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
