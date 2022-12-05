import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tattoo/backend/utils/constants/app/app_constants.dart';
import 'package:tattoo/backend/utils/constants/firebase/design-requests/design_requests_collection_constants.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/design-request/design_model.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/design-request/design_response_image_model.dart';
import '../../../models/design-requests/backend_design_request_model.dart';
import '../../../models/design-requests/backend_design_response_image_model.dart';
import '../../../utils/constants/firebase/design-request-images/design_requests_collection_constants.dart';
import '../../../utils/constants/firebase/users/users_collection_constants.dart';
import '../interface/backend_send_design_request_interface.dart';

class BackendSendDesignRequest extends BackendSendDesignRequestInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference users =
      FirebaseFirestore.instance.collection(UsersCollectionConstants.users);
  CollectionReference designRequests = FirebaseFirestore.instance
      .collection(DesignRequestsCollectionConstants.designRequests);
  CollectionReference designRequestImages = FirebaseFirestore.instance
      .collection(DesignRequestImageCollectionConstants.designRequestImages);
  Reference designRequestImagesReference = FirebaseStorage.instance
      .ref(DesignRequestImageCollectionConstants.designRequestImages);

  @override
  Future<BaseResponse<DesignModel>> sendDesignRequest(
    DesignModel designRequestModel,
  ) async {
    try {
      DocumentReference designRequestsDocumentReference = designRequests.doc();
      Reference designRequestImageReference = designRequestImagesReference
          .child(designRequestsDocumentReference.id);

      await firestore.runTransaction((transaction) async {
        DocumentReference userDocument = users.doc(designRequestModel.userId);
        DocumentSnapshot userDocumentSnapshot =
            await transaction.get(userDocument);

        if (userDocumentSnapshot.exists &&
            userDocumentSnapshot.get("balance") >=
                AppConstants.tattooDesignPrice) {
          await sendFiles(designRequestModel, designRequestImageReference);
          await sendRequests(transaction, designRequestsDocumentReference,
              designRequestModel, designRequestImageReference);
          transaction.update(userDocument, {
            "balance": FieldValue.increment(-AppConstants.tattooDesignPrice)
          });
        } else {
          throw BaseError(message: "Insufficient credits");
        }
      }, maxAttempts: 1).catchError((e) {
        throw e.toString();
      });

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
    Transaction transaction,
    DocumentReference<Object?> designRequestsDocumentReference,
    DesignModel designRequestModel,
    Reference designRequestImageReference,
  ) async {
    transaction.set(
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

        DocumentReference designRequestImagesDocumentReference =
            designRequestImages.doc();

        designRequestModel.designResponseImageModels?.add(
          DesignResponseImageModel(
            id: designRequestImagesDocumentReference.id,
            requestId: designRequestsDocumentReference.id,
            link: link,
            name: element.name,
          ),
        );

        transaction.set(
          designRequestImagesDocumentReference,
          BackendDesignResponseImageModel(
            link: link,
            requestId: designRequestsDocumentReference.id,
            name: element.name,
          ).toJson(),
        );
      }
    }
  }
}
