import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/backend/utils/constants/firebase/design-requests/design_requests_collection_constants.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_success.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/design-request/design_request_image_model.dart';
import '../../../models/design-request-images/backend_design_request_image_model.dart';
import '../interface/backend_design_request_interface.dart';

class BackendDesignRequest extends BackendDesignRequestImageInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference designRequests = FirebaseFirestore.instance
      .collection(DesignRequestsCollectionConstants.designRequests);

  @override
  Future<BaseResponse<DesignRequestImageModel>> createDesignRequestImage(
      DesignRequestImageModel model) async {
    try {
      DocumentReference documentReference = await designRequests.add(
        BackendDesignRequestImageModel.from(
          model: model,
        ),
      );

      model.id = documentReference.id;

      return BaseSuccess<DesignRequestImageModel>(data: model);
    } catch (e) {
      return BaseError();
    }
  }

  @override
  Future<BaseResponse> updateDesignRequestImage(
      DesignRequestImageModel model) async {
    try {
      await designRequests.doc(model.id).update(
            BackendDesignRequestImageModel.from(
              model: model,
            ).toJson(),
          );

      return BaseSuccess();
    } catch (e) {
      return BaseError();
    }
  }
}
