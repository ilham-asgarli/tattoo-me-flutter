import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tattoo/backend/utils/constants/firebase/design-requests/design_requests_collection_constants.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/design-request/design_model.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/design-request/design_response_image_model.dart';
import '../../../models/design-request-images/backend_design_response_image_model.dart';
import '../../../models/design-requests/backend_design_request_model.dart';
import '../../../utils/constants/firebase/design-request-images/design_requests_collection_constants.dart';
import '../interface/backend_send_design_request_interface.dart';

class BackendSendDesignRequest extends BackendSendDesignRequestInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference designRequests = FirebaseFirestore.instance
      .collection(DesignRequestsCollectionConstants.designRequests);
  CollectionReference designRequestImages = FirebaseFirestore.instance
      .collection(DesignRequestImageCollectionConstants.designRequestImages);
  Reference designRequestImagesReference = FirebaseStorage.instance
      .ref(DesignRequestImageCollectionConstants.designRequestImages);

  @override
  Future<BaseResponse<DesignModel>> sendDesignRequest(
      DesignModel designRequestModel) async {
    try {
      DocumentReference designRequestsDocumentReference = designRequests.doc();
      DocumentReference designRequestImagesDocumentReference =
          designRequestImages.doc();
      Reference designRequestImageReference = designRequestImagesReference
          .child(designRequestsDocumentReference.id);

      await sendFiles(designRequestModel, designRequestImageReference);
      await sendRequests(designRequestsDocumentReference, designRequestModel,
          designRequestImageReference, designRequestImagesDocumentReference);

      designRequestModel.id = designRequestsDocumentReference.id;
      return BaseSuccess<DesignModel>(data: designRequestModel);
    } catch (e) {
      return BaseError(message: e.toString());
    }
  }

  Future<void> sendFiles(DesignModel designRequestModel,
      Reference designRequestImageReference) async {
    for (var element in designRequestModel.designRequestImageModels ?? []) {
      if (element.name != null && element.image != null) {
        if (element.image is String) {
          await designRequestImageReference
              .child(element.name!)
              .putFile(File(element.image));
        } else {
          await designRequestImageReference
              .child(element.name!)
              .putData(element.image);
        }
      }
    }
  }

  Future<void> sendRequests(
      DocumentReference<Object?> designRequestsDocumentReference,
      DesignModel designRequestModel,
      Reference designRequestImageReference,
      DocumentReference<Object?> designRequestImagesDocumentReference) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.set(
      designRequestsDocumentReference,
      BackendDesignRequestModel.from(
        model: designRequestModel,
      ).toJson(),
    );

    designRequestModel.designResponseImageModels = [];
    for (var element in designRequestModel.designRequestImageModels ?? []) {
      if (element.name != null) {
        String link = await designRequestImageReference
            .child(element.name!)
            .getDownloadURL();

        designRequestModel.designResponseImageModels
            ?.add(DesignResponseImageModel(
          id: designRequestImagesDocumentReference.id,
          requestId: designRequestsDocumentReference.id,
          link: link,
        ));

        batch.set(
          designRequestImagesDocumentReference,
          BackendDesignResponseImageModel(
                  link: link, requestId: designRequestsDocumentReference.id)
              .toJson(),
        );
      }
    }

    await batch.commit();
  }
}
