import '../../../core/base/models/base_model.dart';
import '../../../core/extensions/map_extension.dart';
import '../../../domain/models/settings/settings_model.dart';

class BackendSettingsModel extends BaseModel<BackendSettingsModel> {
  String? id;
  int? designLimitForOneDesigner;
  Map<String, dynamic>? openTime;
  Map<String, dynamic>? holiday;
  bool? awardedReview;

  BackendSettingsModel({
    this.id,
    this.designLimitForOneDesigner,
    this.openTime,
    this.holiday,
    this.awardedReview,
  });

  BackendSettingsModel.from({required SettingsModel model}) {
    id = model.id;
    designLimitForOneDesigner = model.designLimitForOneDesigner;
    openTime = model.openTime;
    holiday = model.holiday;
    awardedReview = model.awardedReview;
  }

  SettingsModel to({required BackendSettingsModel model}) {
    return SettingsModel(
      id: model.id,
      designLimitForOneDesigner: model.designLimitForOneDesigner,
      openTime: model.openTime,
      holiday: model.holiday,
      awardedReview: model.awardedReview,
    );
  }

  @override
  BackendSettingsModel fromJson(Map<String, dynamic> json) {
    return BackendSettingsModel(
      id: json["id"],
      designLimitForOneDesigner: json["designLimitForOneDesigner"],
      openTime: json["openTime"],
      holiday: json["holiday"],
      awardedReview: json["awardedReview"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.putIfNotNull("designLimitForOneDesigner", designLimitForOneDesigner);
    map.putIfNotNull("openTime", openTime);
    map.putIfNotNull("holiday", holiday);
    map.putIfNotNull("awardedReview", awardedReview);

    return map;
  }
}
