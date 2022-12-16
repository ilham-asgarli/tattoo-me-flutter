import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_success.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/design-request/design_request_image_model_2.dart';
import '../../../models/design-requests/backend_design_request_image_model.dart';
import '../../../utils/constants/firebase/design-request-images/design_requests_collection_constants.dart';
import '../interfaces/backend_design_request_images_interface.dart';

class BackendDesignRequestImage extends BackendDesignRequestImagesInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference designRequestImages = FirebaseFirestore.instance
      .collection(DesignRequestImageCollectionConstants.designRequestImages);

  @override
  Future<BaseResponse<DesignRequestImageModel2>> createDesignRequestImage(
      DesignRequestImageModel2 model) async {
    try {
      DocumentReference documentReference = await designRequestImages.add(
        BackendDesignRequestImageModel.from(
          model: model,
        ).toJson(),
      );

      model.id = documentReference.id;

      return BaseSuccess<DesignRequestImageModel2>(data: model);
    } catch (e) {
      return BaseError();
    }
  }

  @override
  Future<BaseResponse> updateDesignRequestImage(
      DesignRequestImageModel2 model) async {
    try {
      await designRequestImages.doc(model.id).update(
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
