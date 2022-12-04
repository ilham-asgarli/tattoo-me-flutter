import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_success.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/design-request/design_response_image_model.dart';
import '../../../models/design-request-images/backend_design_response_image_model.dart';
import '../../../utils/constants/firebase/design-request-images/design_requests_collection_constants.dart';
import '../interface/backend_design_request_interface.dart';

class BackendDesignRequestImage extends BackendDesignRequestImageInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference designRequestImages = FirebaseFirestore.instance
      .collection(DesignRequestImageCollectionConstants.designRequestImages);

  @override
  Future<BaseResponse<DesignResponseImageModel>> createDesignRequestImage(
      DesignResponseImageModel model) async {
    try {
      DocumentReference documentReference = await designRequestImages.add(
        BackendDesignResponseImageModel.from(
          model: model,
        ).toJson(),
      );

      model.id = documentReference.id;

      return BaseSuccess<DesignResponseImageModel>(data: model);
    } catch (e) {
      return BaseError();
    }
  }

  @override
  Future<BaseResponse> updateDesignRequestImage(
      DesignResponseImageModel model) async {
    try {
      await designRequestImages.doc(model.id).update(
            BackendDesignResponseImageModel.from(
              model: model,
            ).toJson(),
          );

      return BaseSuccess();
    } catch (e) {
      return BaseError();
    }
  }
}
