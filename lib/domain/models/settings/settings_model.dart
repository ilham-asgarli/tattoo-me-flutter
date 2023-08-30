import '../../../core/base/models/base_model.dart';

class SettingsModel extends BaseModel<SettingsModel> {
  String? id;
  int? designLimitForOneDesigner;
  Map<String, dynamic>? openTime;
  Map<String, dynamic>? holiday;
  bool? awardedReview;
  int? activeDesignerTime;

  SettingsModel({
    this.id,
    this.designLimitForOneDesigner,
    this.openTime,
    this.activeDesignerTime,
    this.holiday,
    this.awardedReview,
  });

  @override
  SettingsModel fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json["id"],
      designLimitForOneDesigner: json["designLimitForOneDesigner"],
      openTime: json["openTime"],
      holiday: json["holiday"],
      awardedReview: json["awardedReview"],
      activeDesignerTime: json["activeDesignerTime"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "designLimitForOneDesigner": designLimitForOneDesigner,
      "openTime": openTime,
      "holiday": holiday,
      "awardedReview": awardedReview,
      "activeDesignerTime": activeDesignerTime,
    };
  }
}
