import '../../../core/base/models/base_model.dart';
import '../../../core/extensions/map_extension.dart';
import '../../../domain/models/settings/settings_model.dart';

class BackendSettingsModel extends BaseModel<BackendSettingsModel> {
  String? id;
  int? designLimitForOneDesigner;
  bool? awardedReview;
  bool? takingOrder;
  bool? giveCreditOnFirstEnter;

  BackendSettingsModel({
    this.id,
    this.designLimitForOneDesigner,
    this.awardedReview,
    this.takingOrder,
    this.giveCreditOnFirstEnter,
  });

  BackendSettingsModel.from({required SettingsModel model}) {
    id = model.id;
    designLimitForOneDesigner = model.designLimitForOneDesigner;
    awardedReview = model.awardedReview;
    takingOrder = model.takingOrder;
    giveCreditOnFirstEnter = model.giveCreditOnFirstEnter;
  }

  SettingsModel to({required BackendSettingsModel model}) {
    return SettingsModel(
      id: model.id,
      designLimitForOneDesigner: model.designLimitForOneDesigner,
      awardedReview: model.awardedReview,
      takingOrder: model.takingOrder,
      giveCreditOnFirstEnter: model.giveCreditOnFirstEnter,
    );
  }

  @override
  BackendSettingsModel fromJson(Map<String, dynamic> json) {
    return BackendSettingsModel(
      id: json["id"],
      designLimitForOneDesigner: json["designLimitForOneDesigner"],
      awardedReview: json["awardedReview"],
      takingOrder: json["takingOrder"],
      giveCreditOnFirstEnter: json["giveCreditOnFirstEnter"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.putIfNotNull("designLimitForOneDesigner", designLimitForOneDesigner);
    map.putIfNotNull("awardedReview", awardedReview);
    map.putIfNotNull("takingOrder", takingOrder);
    map.putIfNotNull("giveCreditOnFirstEnter", giveCreditOnFirstEnter);

    return map;
  }
}
