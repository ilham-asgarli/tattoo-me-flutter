import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../domain/models/design-request/design_request_model.dart';
import '../../../../domain/models/design-response/design_response_model.dart';
import '../../../models/design-requests/backend_design_request_image_model.dart';
import '../../../models/design-requests/backend_design_request_model.dart';
import '../../../models/design-responses/backend_design_response_model.dart';
import '../../../utils/constants/firebase/design-request-images/design_requests_collection_constants.dart';
import '../../../utils/constants/firebase/design-requests/design_requests_collection_constants.dart';
import '../interfaces/backend_get_design_response_interface.dart';

class BackendGetDesignResponse extends BackendGetDesignResponseInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference designRequests = FirebaseFirestore.instance
      .collection(DesignRequestsCollectionConstants.designRequests);
  CollectionReference designRequestImages = FirebaseFirestore.instance
      .collection(DesignRequestImageCollectionConstants.designRequestImages);
  CollectionReference designResponses =
      FirebaseFirestore.instance.collection("design-responses");

  @override
  Stream<BaseResponse<List<DesignResponseModel>>> getDesignResponseStream(
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
              return b.designRequestModel?.createdDate?.compareTo(
                      a.designRequestModel?.createdDate ?? DateTime.now()) ??
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
  Future<BaseResponse<DesignResponseModel>> getDesignResponse(
      String designResponseId) async {
    try {
      DocumentSnapshot designResponsesDocumentSnapshot =
          await designResponses.doc(designResponseId).get();
      Map<String, dynamic>? designResponseData =
          designResponsesDocumentSnapshot.data() as Map<String, dynamic>?;

      if (designResponseData != null) {
        BackendDesignResponseModel backendDesignResponseModel =
            BackendDesignResponseModel().fromJson(designResponseData);
        backendDesignResponseModel.id = designResponsesDocumentSnapshot.id;

        DesignResponseModel designResponseModel = backendDesignResponseModel.to(
          model: backendDesignResponseModel,
        );

        DocumentSnapshot designRequestDocumentSnapshot = await designRequests
            .doc(backendDesignResponseModel.requestId)
            .get();
        Map<String, dynamic>? designRequestData =
            designRequestDocumentSnapshot.data() as Map<String, dynamic>?;

        if (designRequestData != null) {
          BackendDesignRequestModel backendDesignRequestModel =
              BackendDesignRequestModel().fromJson(designRequestData);
          backendDesignRequestModel.id = designRequestDocumentSnapshot.id;

          // images

          QuerySnapshot designRequestImagesQuerySnapshot =
              await designRequestImages
                  .where(
                      "requestId",
                      isEqualTo: backendDesignRequestModel.previousRequestId ??
                          backendDesignRequestModel.id)
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

          backendDesignRequestModel.designResponseImageModels =
              designResponseImageModels;

          // images

          DesignRequestModel designRequestModel = backendDesignRequestModel.to(
            model: backendDesignRequestModel,
          );

          designResponseModel.designRequestModel = designRequestModel;

          return BaseSuccess(data: designResponseModel);
        }

        return BaseError();
      }

      return BaseError();
    } catch (e) {
      return BaseError(message: e.toString());
    }
  }
}
