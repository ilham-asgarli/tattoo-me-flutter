import '../../../core/base/models/base_model.dart';

class SettingsModel extends BaseModel<SettingsModel> {
  String? id;
  int? designLimitForOneDesigner;
  bool? awardedReview;
  int? activeDesignerTime;
  bool? takingOrder;
  bool? giveCreditOnFirstEnter;

  SettingsModel({
    this.id,
    this.designLimitForOneDesigner,
    this.activeDesignerTime,
    this.awardedReview,
    this.takingOrder,
    this.giveCreditOnFirstEnter,
  });

  @override
  SettingsModel fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json["id"],
      designLimitForOneDesigner: json["designLimitForOneDesigner"],
      awardedReview: json["awardedReview"],
      activeDesignerTime: json["activeDesignerTime"],
      takingOrder: json["takingOrder"],
      giveCreditOnFirstEnter: json["giveCreditOnFirstEnter"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "designLimitForOneDesigner": designLimitForOneDesigner,
      "awardedReview": awardedReview,
      "activeDesignerTime": activeDesignerTime,
      "takingOrder": takingOrder,
      "giveCreditOnFirstEnter": giveCreditOnFirstEnter,
    };
  }
}
