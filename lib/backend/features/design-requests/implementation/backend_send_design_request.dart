import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../domain/models/design-request/design_request_image_model_2.dart';
import '../../../../domain/models/design-request/design_request_model.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/errors/design_request_errors/first_order_insufficient_balance_error.dart';
import '../../../../utils/logic/errors/design_request_errors/insufficient_balance_error.dart';
import '../../../../utils/logic/errors/design_request_errors/no_designer_error.dart';
import '../../../../utils/logic/errors/design_request_errors/no_internet.dart';
import '../../../../utils/logic/errors/design_request_errors/not_taking_order_error.dart';
import '../../../../utils/logic/errors/design_request_errors/out_of_work_hours_error.dart';
import '../../../../utils/logic/errors/design_request_errors/retouched_before_error.dart';
import '../../../models/auth/backend_user_model.dart';
import '../../../models/design-requests/backend_design_request_image_model.dart';
import '../../../models/design-requests/backend_design_request_model.dart';
import '../../../models/retouches/backend_retouches_model.dart';
import '../../../utils/constants/app/app_constants.dart';
import '../../../utils/constants/firebase/design-request-images/design_requests_collection_constants.dart';
import '../../../utils/constants/firebase/design-requests/design_requests_collection_constants.dart';
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
  CollectionReference retouches =
      FirebaseFirestore.instance.collection("retouches");
  CollectionReference settings =
      FirebaseFirestore.instance.collection("settings");

  Reference designRequestImagesReference = FirebaseStorage.instance
      .ref(DesignRequestImageCollectionConstants.designRequestImages);

  late DocumentReference designRequestsSettings;

  BackendSendDesignRequest() {
    designRequestsSettings = settings.doc("design-request");
  }

  @override
  Future<BaseSuccess<DesignRequestModel>> sendDesignRequest(
    DesignRequestModel designRequestModel,
  ) async {
    try {
      DocumentReference designRequestsDocumentReference = designRequests.doc();
      Reference designRequestImageReference = designRequestImagesReference
          .child(designRequestsDocumentReference.id);

      await firestore.runTransaction((transaction) async {
        DocumentSnapshot designRequestsSettingsDocument =
            await transaction.get(designRequestsSettings);

        if (!designRequestsSettingsDocument.exists ||
            !designRequestsSettingsDocument.get("takingOrder")) {
          throw 1;
        }

        DocumentReference userDocument = users.doc(designRequestModel.userId);
        DocumentSnapshot userDocumentSnapshot =
            await transaction.get(userDocument);

        Map<String, dynamic>? userData =
            userDocumentSnapshot.data() as Map<String, dynamic>?;

        if (userData == null) {
          throw BaseError();
        }

        BackendUserModel backendUserModel =
            BackendUserModel().fromJson(userData);

        if (userDocumentSnapshot.exists &&
            backendUserModel.balance >= AppBackConstants.tattooDesignPrice) {
          await sendFiles(designRequestModel, designRequestImageReference);

          String? designerId = await assignDesigner(
              designLimitForOneDesigner: designRequestsSettingsDocument
                  .get("designLimitForOneDesigner"));
          if (designerId == null) {
            throw 5;
          }
          designRequestModel.designerId = designerId;

          await sendRequests(transaction, designRequestsDocumentReference,
              designRequestModel, designRequestImageReference);
          transaction.update(
            userDocument,
            BackendUserModel(
              balance:
                  FieldValue.increment(-AppBackConstants.tattooDesignPrice),
              isSpentCredit: true,
            ).toJson(),
          );
        } else {
          if (backendUserModel.isFirstOrderInsufficientBalance ?? true) {
            throw 3;
          } else {
            throw 4;
          }
        }
      }, maxAttempts: 1).catchError((e) {
        throw e;
      });

      designRequestModel.id = designRequestsDocumentReference.id;
      return BaseSuccess<DesignRequestModel>(data: designRequestModel);
    } on PlatformException catch (e) {
      if (e.code == "firebase_firestore") {
        if (e.details["code"] == "unavailable") {
          throw NoInternet(message: e.toString());
        }
      }
      throw BaseError(message: e.toString());
    } catch (e) {
      switch (e) {
        case 1:
          throw NotTakingOrderError(message: LocaleKeys.notTakingOrder.tr());
        case 2:
          throw OutOfWorkHoursError(message: LocaleKeys.outOfWorkingHours.tr());
        case 3:
          throw FirstOrderInsufficientBalanceError(
              message: LocaleKeys.insufficientBalanceReview.tr());
        case 4:
          throw InsufficientBalanceError(
              message: LocaleKeys.insufficientBalance.tr());
        case 5:
          throw NoDesignerError(message: LocaleKeys.noDesigner.tr());
        default:
          throw BaseError(message: e.toString());
      }
    }
  }

  @override
  Future<BaseSuccess<DesignRequestModel>> sendRetouchDesignRequest(
      DesignRequestModel designRequestModel, String comment) async {
    try {
      DocumentReference designRequestDocumentReference = designRequests.doc();

      await firestore.runTransaction((transaction) async {
        DocumentSnapshot designRequestsSettingsDocument =
            await transaction.get(designRequestsSettings);

        if (!designRequestsSettingsDocument.exists ||
            !designRequestsSettingsDocument.get("takingOrder")) {
          throw 1;
        }

        /*DateTime now = (await NTP.now()).toUtc().add(const Duration(hours: 3));

        if (now.hour < designRequestsSettingsDocument.get("workHours")[0] ||
            now.hour >= designRequestsSettingsDocument.get("workHours")[1]) {
          throw 2;
        }*/

        DocumentReference designRequestDocument =
            designRequests.doc(designRequestModel.previousRequestId);
        DocumentSnapshot designRequestDocumentSnapshot =
            await transaction.get(designRequestDocument);

        Map<String, dynamic>? designRequestData =
            designRequestDocumentSnapshot.data() as Map<String, dynamic>?;

        if (designRequestData != null) {
          BackendDesignRequestModel backendDesignRequestModel =
              BackendDesignRequestModel().fromJson(designRequestData);

          if (backendDesignRequestModel.previousRequestId == null &&
              backendDesignRequestModel.retouchId == null) {
            String? designerId = await assignDesigner(
              designLimitForOneDesigner: designRequestsSettingsDocument
                  .get("designLimitForOneDesigner"),
              previousDesignerId: designRequestModel.designerId,
            );
            if (designerId == null) {
              throw 4;
            }
            designRequestModel.designerId = designerId;

            await sendRetouchRequests(
              transaction,
              designRequestDocumentReference,
              designRequestModel,
              comment,
            );
          } else {
            throw 3;
          }
        }
      }, maxAttempts: 1).catchError((e) {
        switch (e) {
          case 1:
            throw NotTakingOrderError(message: LocaleKeys.notTakingOrder.tr());
          case 2:
            throw OutOfWorkHoursError(
                message: LocaleKeys.outOfWorkingHours.tr());
          case 3:
            throw RetouchedBeforeError(
                message: LocaleKeys.retouchedBefore.tr());
          case 4:
            throw NoDesignerError(message: LocaleKeys.noDesigner.tr());
          default:
            throw BaseError(message: e.toString());
        }
      });

      designRequestModel.id = designRequestDocumentReference.id;
      return BaseSuccess<DesignRequestModel>(data: designRequestModel);
    } catch (e) {
      throw BaseError(message: e.toString());
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
    BackendDesignRequestModel backendDesignRequestModel =
        BackendDesignRequestModel.from(
      model: designRequestModel,
    );
    backendDesignRequestModel.createdDate = FieldValue.serverTimestamp();

    transaction.set(
      designRequestsDocumentReference,
      backendDesignRequestModel.toJson(),
    );

    designRequestModel.designRequestImageModels2 = [];
    for (var element in designRequestModel.designRequestImageModels1 ?? []) {
      if (element.name != null) {
        String link = await designRequestImageReference
            .child(element.name!)
            .getDownloadURL();

        DocumentReference designRequestImagesDocumentReference =
            designRequestImages.doc();

        DesignRequestImageModel2 designRequestImageModel2 =
            DesignRequestImageModel2(
          id: designRequestImagesDocumentReference.id,
          requestId: designRequestsDocumentReference.id,
          link: link,
          name: element.name,
        );

        designRequestModel.designRequestImageModels2
            ?.add(designRequestImageModel2);

        transaction.set(
          designRequestImagesDocumentReference,
          BackendDesignRequestImageModel.from(model: designRequestImageModel2)
              .toJson(),
        );
      }
    }
  }

  Future<void> sendRetouchRequests(
    Transaction transaction,
    DocumentReference<Object?> designRequestsDocumentReference,
    DesignRequestModel designRequestModel,
    String comment,
  ) async {
    BackendDesignRequestModel backendDesignRequestModel =
        BackendDesignRequestModel.from(
      model: designRequestModel,
    );
    backendDesignRequestModel.createdDate = FieldValue.serverTimestamp();

    transaction.set(
      designRequestsDocumentReference,
      backendDesignRequestModel.toJson(),
    );

    DocumentReference retouchesDocumentReference = retouches.doc();
    transaction.set(
      retouchesDocumentReference,
      BackendRetouchesModel(
        id: retouchesDocumentReference.id,
        userId: designRequestModel.userId,
        designId: designRequestModel.id,
        comment: comment,
      ).toJson(),
    );

    transaction.update(
      designRequests.doc(designRequestModel.previousRequestId),
      BackendDesignRequestModel(
        retouchId: designRequestsDocumentReference.id,
      ).toJson(),
    );
  }

  Future<String?> assignDesigner({
    required int designLimitForOneDesigner,
    String? previousDesignerId,
  }) async {
    String? designerId;

    if (previousDesignerId != null) {
      DocumentSnapshot previousDesignerDocumentSnapshot =
          await designers.doc(previousDesignerId).get();
      Map<String, dynamic>? previousDesignerData =
          previousDesignerDocumentSnapshot.data() as Map<String, dynamic>?;

      if (previousDesignerData != null && previousDesignerData["working"]) {
        designerId = previousDesignerDocumentSnapshot.id;
      }
    }

    if (designerId == null) {
      QuerySnapshot designersQuerySnapshot =
          await designers.where("working", isEqualTo: true).get();

      if (designersQuerySnapshot.size == 0) {
        designersQuerySnapshot = await designers.get();
      }

      int lastMinAssignmentCount = -1;
      for (DocumentSnapshot workingDesignerDocumentSnapshot
          in designersQuerySnapshot.docs) {
        QuerySnapshot designRequestsQuerySnapshot = await designRequests
            .where("designerId", isEqualTo: workingDesignerDocumentSnapshot.id)
            .where("finished", isEqualTo: false)
            .get();

        if ((lastMinAssignmentCount < 0 ||
                lastMinAssignmentCount > designRequestsQuerySnapshot.size) &&
            designRequestsQuerySnapshot.size <= designLimitForOneDesigner) {
          lastMinAssignmentCount = designRequestsQuerySnapshot.size;
          designerId = workingDesignerDocumentSnapshot.id;
        }
      }
    }

    return designerId;
  }
}
