import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/backend/utils/constants/firebase/design-requests/design_requests_collection_constants.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/design-request/design_request_model.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../models/design-requests/backend_design_request_model.dart';
import '../interface/backend_design_request_interface.dart';

class BackendDesignRequest extends BackendDesignRequestInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference designRequests = FirebaseFirestore.instance
      .collection(DesignRequestsCollectionConstants.designRequests);

  @override
  Future<BaseResponse<DesignRequestModel>> createDesignRequest(
      DesignRequestModel designRequestModel) async {
    try {
      DocumentReference documentReference = await designRequests.add(
        BackendDesignRequestModel.from(
          model: designRequestModel,
        ),
      );

      designRequestModel.id = documentReference.id;

      return BaseSuccess<DesignRequestModel>(data: designRequestModel);
    } catch (e) {
      return BaseError();
    }
  }

  @override
  Future<BaseResponse> updateDesignRequest(
      DesignRequestModel designRequestModel) async {
    try {
      await designRequests.doc(designRequestModel.id).update(
            BackendDesignRequestModel.from(
              model: designRequestModel,
            ).toJson(),
          );

      return BaseSuccess();
    } catch (e) {
      return BaseError();
    }
  }
}
