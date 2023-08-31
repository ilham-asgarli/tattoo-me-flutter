import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ntp/ntp.dart';

import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../domain/models/settings/settings_model.dart';
import '../../../models/settings/backend_settings.dart';
import '../interfaces/backend_settings_interface.dart';

class BackendSettings extends SettingsInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference settings =
      FirebaseFirestore.instance.collection("settings");
  late DocumentReference designRequestsSettings;

  BackendSettings() {
    designRequestsSettings = settings.doc("design-request");
  }

  @override
  Stream<BaseResponse<SettingsModel>> getDesignRequestsSettingsStream() async* {
    try {
      Stream<DocumentSnapshot> settingsStream =
          designRequestsSettings.snapshots();

      await for (DocumentSnapshot designRequestsSettingsSnapshot
          in settingsStream) {
        Map<String, dynamic>? designRequestsSettingsData =
            designRequestsSettingsSnapshot.data() as Map<String, dynamic>?;

        if (designRequestsSettingsData != null) {
          BackendSettingsModel backendSettingsModel =
              BackendSettingsModel().fromJson(
            designRequestsSettingsData,
          );

          backendSettingsModel.id = designRequestsSettingsSnapshot.id;

          SettingsModel? settingsModel = BackendSettingsModel().to(
            model: backendSettingsModel,
          );

          /*settingsModel.activeDesignerTime =
              await calculateActiveDesignerTime(settingsModel);*/

          yield BaseSuccess(
            data: settingsModel,
          );
        }
      }
    } catch (e) {
      yield BaseError(message: e.toString());
    }
  }

  Future<int> calculateActiveDesignerTime(SettingsModel settingsModel) async {
    Map<String, dynamic>? openTime = settingsModel.openTime;
    Map<String, dynamic>? holiday = settingsModel.holiday;

    Map<int, dynamic>? weekDayHoliday = {
      1: holiday?["monday"],
      2: holiday?["tuesday"],
      3: holiday?["wednesday"],
      4: holiday?["thursday"],
      5: holiday?["friday"],
      6: holiday?["saturday"],
      7: holiday?["sunday"],
    };

    DateTime now = await NTP.now();
    DateTime start = now;

    if (weekDayHoliday[now.add(const Duration(days: 1)).weekday]) {
      start = now.add(Duration(
        days: findWorkDayDifference(now, weekDayHoliday),
      ));
    }

    int differenceForTomorrow = start
            .copyWith(
              hour: openTime?["hour"],
              minute: openTime?["minutes"],
            )
            .millisecondsSinceEpoch -
        now.millisecondsSinceEpoch;

    int difference = differenceForTomorrow > 0
        ? differenceForTomorrow
        : (start
                .add(const Duration(days: 1))
                .copyWith(
                  hour: openTime?["hour"],
                  minute: openTime?["minutes"],
                  second: 0,
                  millisecond: 0,
                  microsecond: 0,
                )
                .millisecondsSinceEpoch -
            start.millisecondsSinceEpoch);

    return now.millisecondsSinceEpoch + difference;
  }

  int findWorkDayDifference(DateTime now, Map<int, dynamic>? weekDayHoliday) {
    int difference = 1;

    for (int i = 1; i <= 7; i++) {
      int tomorrow = now.weekday + i;

      if (!weekDayHoliday?[tomorrow <= 7 ? tomorrow : tomorrow - 7]) {
        break;
      }

      difference += 1;
    }

    return difference;
  }
}
