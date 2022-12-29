import '../../../core/base/models/base_model.dart';

class SettingsModel extends BaseModel<SettingsModel> {
  String? id;
  int? designLimitForOneDesigner;
  List<int>? workHours;

  SettingsModel({
    this.id,
    this.designLimitForOneDesigner,
    this.workHours,
  });

  @override
  SettingsModel fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json["id"],
      designLimitForOneDesigner: json["designLimitForOneDesigner"],
      workHours: json["workHours"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "designLimitForOneDesigner": designLimitForOneDesigner,
      "workHours": workHours,
    };
  }
}
