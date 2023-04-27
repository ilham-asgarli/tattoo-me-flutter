import 'package:tattoo/core/base/models/base_model.dart';
import 'package:tattoo/core/extensions/map_extension.dart';
import 'package:tattoo/domain/models/settings/settings_model.dart';

class BackendSettingsModel extends BaseModel<BackendSettingsModel> {
  String? id;
  int? designLimitForOneDesigner;
  List<dynamic>? workHours;
  bool? awardedReview;

  BackendSettingsModel({
    this.id,
    this.designLimitForOneDesigner,
    this.workHours,
    this.awardedReview,
  });

  BackendSettingsModel.from({required SettingsModel model}) {
    id = model.id;
    designLimitForOneDesigner = model.designLimitForOneDesigner;
    workHours = model.workHours;
    awardedReview = model.awardedReview;
  }

  SettingsModel to({required BackendSettingsModel model}) {
    return SettingsModel(
      id: model.id,
      designLimitForOneDesigner: model.designLimitForOneDesigner,
      workHours: model.workHours,
      awardedReview: model.awardedReview,
    );
  }

  @override
  BackendSettingsModel fromJson(Map<String, dynamic> json) {
    return BackendSettingsModel(
      id: json["id"],
      designLimitForOneDesigner: json["designLimitForOneDesigner"],
      workHours: json["workHours"],
      awardedReview: json["awardedReview"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.putIfNotNull("designLimitForOneDesigner", designLimitForOneDesigner);
    map.putIfNotNull("workHours", workHours);
    map.putIfNotNull("awardedReview", awardedReview);

    return map;
  }
}
