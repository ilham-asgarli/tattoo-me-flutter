import '../../../core/base/models/base_model.dart';

class SettingsModel extends BaseModel<SettingsModel> {
  String? id;
  int? designLimitForOneDesigner;
  List<dynamic>? workHours;
  bool? awardedReview;

  SettingsModel({
    this.id,
    this.designLimitForOneDesigner,
    this.workHours,
    this.awardedReview,
  });

  @override
  SettingsModel fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json["id"],
      designLimitForOneDesigner: json["designLimitForOneDesigner"],
      workHours: json["workHours"],
      awardedReview: json["awardedReview"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "designLimitForOneDesigner": designLimitForOneDesigner,
      "workHours": workHours,
      "awardedReview": awardedReview,
    };
  }
}
