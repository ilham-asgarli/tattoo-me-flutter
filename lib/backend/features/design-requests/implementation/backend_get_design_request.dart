import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/backend/models/design-requests/backend_design_request_model.dart';
import 'package:tattoo/backend/models/design-responses/backend_design_response_model.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/design-request/design_request_model.dart';

import '../../../../domain/models/design-response/design_response_model.dart';
import '../../../models/design-requests/backend_design_request_image_model.dart';
import '../../../utils/constants/firebase/design-request-images/design_requests_collection_constants.dart';
import '../../../utils/constants/firebase/design-requests/design_requests_collection_constants.dart';
import '../interfaces/backend_get_design_request_interface.dart';

class BackendGetDesignRequest extends BackendGetDesignRequestInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference designRequests = FirebaseFirestore.instance
      .collection(DesignRequestsCollectionConstants.designRequests);
  CollectionReference designRequestImages = FirebaseFirestore.instance
      .collection(DesignRequestImageCollectionConstants.designRequestImages);
  CollectionReference designResponses =
      FirebaseFirestore.instance.collection("design-responses");

  @override
  Future<BaseResponse<DesignRequestModel>> getDesignRequest(
      String userId) async {
    try {
      DocumentSnapshot designRequestsDocumentSnapshot =
          await designRequests.doc(userId).get();
      Map<String, dynamic>? designRequestsData =
          designRequestsDocumentSnapshot.data() as Map<String, dynamic>?;

      QuerySnapshot designRequestImagesQuerySnapshot = await designRequestImages
          .where("requestId", isEqualTo: designRequestsDocumentSnapshot.id)
          .get();

      List<BackendDesignRequestImageModel> designResponseImageModels = [];
      for (var element in designRequestImagesQuerySnapshot.docs) {
        Map<String, dynamic>? designRequestImagesData =
            element.data() as Map<String, dynamic>?;
        if (designRequestImagesData != null) {
          BackendDesignRequestImageModel backendDesignResponseImageModel =
              BackendDesignRequestImageModel()
                  .fromJson(designRequestImagesData);
          backendDesignResponseImageModel.id = element.id;
          designResponseImageModels.add(backendDesignResponseImageModel);
        }
      }

      if (designRequestsData != null) {
        BackendDesignRequestModel backendDesignRequestModel =
            BackendDesignRequestModel().fromJson(designRequestsData);
        backendDesignRequestModel.designResponseImageModels =
            designResponseImageModels;

        return BaseSuccess<DesignRequestModel>(
            data: BackendDesignRequestModel().to(
          model: backendDesignRequestModel,
        ));
      } else {
        return BaseSuccess<DesignRequestModel>(data: DesignRequestModel());
      }
    } catch (e) {
      return BaseError(message: e.toString());
    }
  }

  @override
  Stream<BaseResponse<List<DesignResponseModel>>> getDesignRequestStream(
      String userId) async* {
    try {
      Stream<QuerySnapshot> designRequestsStream =
          designRequests.where("userId", isEqualTo: userId).snapshots();

      await for (QuerySnapshot designRequestsDocumentSnapshot
          in designRequestsStream) {
        if (designRequestsDocumentSnapshot.size == 0) {
          yield BaseError(message: "Empty");
        } else {
          List<DesignResponseModel> designResponseModels = [];

          for (var element in designRequestsDocumentSnapshot.docs) {
            Map<String, dynamic>? designRequestsData =
                element.data() as Map<String, dynamic>?;

            if (designRequestsData != null) {
              BackendDesignRequestModel backendDesignRequestModel =
                  BackendDesignRequestModel().fromJson(designRequestsData);

              /*if (backendDesignRequestModel.retouchId != null) {
              continue;
            }*/

              QuerySnapshot designRequestImagesQuerySnapshot =
                  await designRequestImages
                      .where("requestId",
                          isEqualTo:
                              backendDesignRequestModel.previousRequestId ??
                                  element.id)
                      .get();

              List<BackendDesignRequestImageModel> designResponseImageModels =
                  [];
              for (var element in designRequestImagesQuerySnapshot.docs) {
                Map<String, dynamic>? designRequestImagesData =
                    element.data() as Map<String, dynamic>?;
                if (designRequestImagesData != null) {
                  BackendDesignRequestImageModel
                      backendDesignResponseImageModel =
                      BackendDesignRequestImageModel()
                          .fromJson(designRequestImagesData);
                  backendDesignResponseImageModel.id = element.id;

                  designResponseImageModels
                      .add(backendDesignResponseImageModel);
                }
              }

              backendDesignRequestModel.designResponseImageModels =
                  designResponseImageModels;

              QuerySnapshot designResponsesQuerySnapshot = await designResponses
                  .where("requestId", isEqualTo: element.id)
                  .get();

              BackendDesignResponseModel backendDesignResponseModel;
              if (designResponsesQuerySnapshot.size > 0) {
                Map<String, dynamic>? designResponseData =
                    designResponsesQuerySnapshot.docs.first.data()
                        as Map<String, dynamic>?;

                if (designResponseData != null) {
                  backendDesignResponseModel =
                      BackendDesignResponseModel().fromJson(designResponseData);
                  backendDesignResponseModel.id =
                      designResponsesQuerySnapshot.docs.first.id;
                } else {
                  yield BaseSuccess<List<DesignResponseModel>>(
                    data: designResponseModels,
                  );
                  continue;
                }
              } else {
                backendDesignResponseModel = BackendDesignResponseModel();
              }

              if (backendDesignResponseModel.deleted ?? false) {
                yield BaseSuccess<List<DesignResponseModel>>(
                  data: designResponseModels,
                );
                continue;
              }

              designResponseModels.add(
                BackendDesignResponseModel().to(
                  model: backendDesignResponseModel,
                ),
              );

              designResponseModels.last.designRequestModel =
                  BackendDesignRequestModel().to(
                model: backendDesignRequestModel,
              );
              designResponseModels.last.designRequestModel?.id = element.id;
            }

            designResponseModels.sort((a, b) {
              return a.designRequestModel?.createdDate?.compareTo(
                      b.designRequestModel?.createdDate ?? DateTime.now()) ??
                  0;
            });

            designResponseModels.sort((a, b) {
              if (b.designRequestModel?.finished ?? false) {
                return -1;
              }
              return 1;
            });
          }

          yield BaseSuccess<List<DesignResponseModel>>(
            data: designResponseModels,
          );
        }
      }
    } catch (e) {
      yield BaseError(message: e.toString());
    }
  }

  @override
  Stream<BaseResponse<List<DesignRequestModel>>>
      getNotFinishedDesignRequestForDesignerStream(
          DesignRequestModel? designRequestModel) async* {
    try {
      Stream<QuerySnapshot> designRequestsStream = designRequests
          .where("designerId", isEqualTo: designRequestModel?.designerId)
          .where("finished", isEqualTo: false)
          .orderBy("createdDate")
          .endAtDocument(await designRequests.doc(designRequestModel?.id).get())
          .snapshots();

      await for (QuerySnapshot designResponseDocumentSnapshot
          in designRequestsStream) {
        if (designResponseDocumentSnapshot.size == 0) {
          yield BaseError(message: "Empty");
        } else {
          List<DesignRequestModel> designRequestModels = [];

          for (var documentSnapshot in designResponseDocumentSnapshot.docs) {
            Map<String, dynamic>? designRequestData =
                documentSnapshot.data() as Map<String, dynamic>?;

            if (designRequestData != null) {
              BackendDesignRequestModel backenddesignRequestModel =
                  BackendDesignRequestModel().fromJson(designRequestData);
              backenddesignRequestModel.id = documentSnapshot.id;
              designRequestModels.add(
                BackendDesignRequestModel().to(
                  model: backenddesignRequestModel,
                ),
              );
            }
          }

          yield BaseSuccess<List<DesignRequestModel>>(
            data: designRequestModels,
          );
        }
      }
    } catch (e) {
      yield BaseError(message: e.toString());
    }
  }
}
