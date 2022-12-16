import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tattoo/backend/utils/constants/app/app_constants.dart';
import 'package:tattoo/backend/utils/constants/firebase/design-requests/design_requests_collection_constants.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/design-request/design_request_model.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/design-request/design_request_image_model_2.dart';
import '../../../models/design-requests/backend_design_request_image_model.dart';
import '../../../models/design-requests/backend_design_request_model.dart';
import '../../../utils/constants/firebase/design-request-images/design_requests_collection_constants.dart';
import '../../../utils/constants/firebase/users/users_collection_constants.dart';
import '../interfaces/backend_send_design_request_interface.dart';

class BackendSendDesignRequest extends BackendSendDesignRequestInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference users =
      FirebaseFirestore.instance.collection(UsersCollectionConstants.users);
  CollectionReference designRequests = FirebaseFirestore.instance
      .collection(DesignRequestsCollectionConstants.designRequests);
  CollectionReference designRequestImages = FirebaseFirestore.instance
      .collection(DesignRequestImageCollectionConstants.designRequestImages);
  CollectionReference designers =
      FirebaseFirestore.instance.collection("designers");
  Reference designRequestImagesReference = FirebaseStorage.instance
      .ref(DesignRequestImageCollectionConstants.designRequestImages);

  @override
  Future<BaseResponse<DesignRequestModel>> sendDesignRequest(
    DesignRequestModel designRequestModel,
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

          String? designerId = await assignDesigner();
          if (designerId == null) {
            throw BaseError(message: "No designer");
          }
          designRequestModel.designerId = designerId;

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
      return BaseSuccess<DesignRequestModel>(data: designRequestModel);
    } catch (e) {
      return BaseError(message: e.toString());
    }
  }

  Future<void> sendFiles(DesignRequestModel designRequestModel,
      Reference designRequestImageReference) async {
    for (var element in designRequestModel.designRequestImageModels1 ?? []) {
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
    DesignRequestModel designRequestModel,
    Reference designRequestImageReference,
  ) async {
    transaction.set(
      designRequestsDocumentReference,
      BackendDesignRequestModel.from(
        model: designRequestModel,
      ).toJson(),
    );

    designRequestModel.designRequestImageModels2 = [];
    for (var element in designRequestModel.designRequestImageModels1 ?? []) {
      if (element.name != null) {
        String link = await designRequestImageReference
            .child(element.name!)
            .getDownloadURL();

        DocumentReference designRequestImagesDocumentReference =
            designRequestImages.doc();

        designRequestModel.designRequestImageModels2?.add(
          DesignRequestImageModel2(
            id: designRequestImagesDocumentReference.id,
            requestId: designRequestsDocumentReference.id,
            link: link,
            name: element.name,
          ),
        );

        transaction.set(
          designRequestImagesDocumentReference,
          BackendDesignRequestImageModel(
            link: link,
            requestId: designRequestsDocumentReference.id,
            name: element.name,
          ).toJson(),
        );
      }
    }
  }

  Future<String?> assignDesigner() async {
    QuerySnapshot workingDesignersQuerySnapshot =
        await designers.where("working", isEqualTo: true).get();

    String? designerId;
    int lastMinAssignmentCount = -1;
    for (DocumentSnapshot workingDesignerDocumentSnapshot
        in workingDesignersQuerySnapshot.docs) {
      QuerySnapshot designRequestsQuerySnapshot = await designRequests
          .where("designerId", isEqualTo: workingDesignerDocumentSnapshot.id)
          .get();

      if (lastMinAssignmentCount < 0 ||
          lastMinAssignmentCount > designRequestsQuerySnapshot.size) {
        lastMinAssignmentCount = designRequestsQuerySnapshot.size;
        designerId = workingDesignerDocumentSnapshot.id;
      }
    }

    return designerId;
  }
}