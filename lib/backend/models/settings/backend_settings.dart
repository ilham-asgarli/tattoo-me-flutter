import 'package:tattoo/core/base/models/base_model.dart';
import 'package:tattoo/core/extensions/map_extension.dart';
import 'package:tattoo/domain/models/settings/settings_model.dart';

class BackendSettingsModel extends BaseModel<BackendSettingsModel> {
  String? id;
  int? designLimitForOneDesigner;
  List<dynamic>? workHours;

  BackendSettingsModel({
    this.id,
    this.designLimitForOneDesigner,
    this.workHours,
  });

  BackendSettingsModel.from({required SettingsModel model}) {
    id = model.id;
    designLimitForOneDesigner = model.designLimitForOneDesigner;
    workHours = model.workHours;
  }

  SettingsModel to({required BackendSettingsModel model}) {
    return SettingsModel(
      id: model.id,
      designLimitForOneDesigner: model.designLimitForOneDesigner,
      workHours: model.workHours,
    );
  }

  @override
  BackendSettingsModel fromJson(Map<String, dynamic> json) {
    return BackendSettingsModel(
      id: json["id"],
      designLimitForOneDesigner: json["designLimitForOneDesigner"],
      workHours: json["workHours"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.putIfNotNull("designLimitForOneDesigner", designLimitForOneDesigner);
    map.putIfNotNull("workHours", workHours);

    return map;
  }
}
