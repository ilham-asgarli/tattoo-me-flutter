import 'package:cloud_firestore/cloud_firestore.dart';

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
          yield BaseSuccess(
            data: BackendSettingsModel().to(
                model: BackendSettingsModel().fromJson(
              designRequestsSettingsData,
            )),
          );
        }
      }
    } catch (e) {
      yield BaseError(message: e.toString());
    }
  }
}
