import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/backend/features/design-requests/implementation/backend_get_design_request.dart';
import 'package:tattoo/backend/models/design-requests/backend_design_request_model.dart';
import 'package:tattoo/backend/models/design-responses/backend_design_response_model.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/design-response/design_response_model.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/design-request/design_request_model.dart';
import '../interfaces/backend_design_request_interface.dart';

class BackendDesignResponse extends BackendDesignResponseInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference designResponses =
      FirebaseFirestore.instance.collection("design-responses");
  CollectionReference designRequests =
      FirebaseFirestore.instance.collection("design-requests");

  @override
  Future<BaseResponse> updateDesignResponse(
      DesignResponseModel designResponseModel) async {
    try {
      await designResponses.doc(designResponseModel.id ?? "").update(
            BackendDesignResponseModel.from(model: designResponseModel)
                .toJson(),
          );

      return BaseSuccess();
    } catch (e) {
      return BaseError();
    }
  }

  @override
  Future<BaseResponse> deleteDesign(String designId) async {
    return await updateDesignResponse(DesignResponseModel(
      id: designId,
      deleted: true,
    ));
  }

  @override
  Future<BaseResponse> evaluateDesigner(String designId, int rating) async {
    return await updateDesignResponse(DesignResponseModel(
      id: designId,
      rating: rating,
    ));
  }

  @override
  Future<BaseResponse<DesignResponseModel>> getDesignResponse(
      String requestId) async {
    try {
      Stream<QuerySnapshot> designRequestsStream =
          designResponses.where("requestId", isEqualTo: requestId).snapshots();

      await for (QuerySnapshot designResponseDocumentSnapshot
          in designRequestsStream) {
        if (designResponseDocumentSnapshot.size == 0) {
          return BaseError(message: "Empty");
        } else {
          BackendGetDesignRequest backendGetDesignRequest = BackendGetDesignRequest();
          BaseResponse<DesignRequestModel> requestBaseResponse = await backendGetDesignRequest.getDesignRequest(requestId);

          if(requestBaseResponse is BaseSuccess<DesignRequestModel>) {
            Map<String, dynamic>? designResponseData =
            designResponseDocumentSnapshot.docs.first.data()
            as Map<String, dynamic>?;

            if (designResponseData != null) {
              BackendDesignResponseModel backendDesignResponseModel =
              BackendDesignResponseModel().fromJson(designResponseData);
              backendDesignResponseModel.id =
                  designResponseDocumentSnapshot.docs.first.id;

              DesignResponseModel designResponseModel = BackendDesignResponseModel().to(
                model: backendDesignResponseModel,
              );
              designResponseModel.designRequestModel = requestBaseResponse.data;

              return BaseSuccess<DesignResponseModel>(
                data: designResponseModel,
              );
            }
          }
        }
      }

      return BaseError();
    } catch (e) {
      return BaseError(message: e.toString());
    }
  }

  @override
  Stream<BaseResponse<DesignResponseModel>> getDesignRequestStream(
      String requestId) async* {
    try {
      Stream<QuerySnapshot> designRequestsStream =
          designResponses.where("requestId", isEqualTo: requestId).snapshots();

      await for (QuerySnapshot designResponseDocumentSnapshot
          in designRequestsStream) {
        if (designResponseDocumentSnapshot.size == 0) {
          yield BaseError(message: "Empty");
        } else {
          Map<String, dynamic>? designResponseData =
              designResponseDocumentSnapshot.docs.first.data()
                  as Map<String, dynamic>?;

          if (designResponseData != null) {
            BackendDesignResponseModel backendDesignResponseModel =
                BackendDesignResponseModel().fromJson(designResponseData);
            backendDesignResponseModel.id =
                designResponseDocumentSnapshot.docs.first.id;

            yield BaseSuccess<DesignResponseModel>(
              data: BackendDesignResponseModel().to(
                model: backendDesignResponseModel,
              ),
            );
          }
        }
      }
    } catch (e) {
      yield BaseError(message: e.toString());
    }
  }
}
