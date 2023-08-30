import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../domain/models/design-request/design_request_model.dart';
import '../../../models/design-requests/backend_design_request_image_model.dart';
import '../../../models/design-requests/backend_design_request_model.dart';
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
  CollectionReference designers =
      FirebaseFirestore.instance.collection("designers");

  @override
  Future<BaseResponse<DesignRequestModel>> getDesignRequest(
      String requestId) async {
    try {
      DocumentSnapshot designRequestsDocumentSnapshot =
          await designRequests.doc(requestId).get();
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

  @override
  Stream<BaseResponse<int>> getMinRequestDesignerRequestCount() async* {
    try {
      Stream<QuerySnapshot> designRequestsStream = designRequests
          .where("finished", isEqualTo: false)
          .orderBy("createdDate")
          .snapshots();

      Stream<QuerySnapshot> designersStream =
          designers.where("working", isEqualTo: true).snapshots();

      Stream<int> stream =
          Rx.combineLatest2(designRequestsStream, designersStream, (a, b) {
        int min = -1;

        for (var designerDoc in b.docs) {
          Map<String, dynamic>? designersData =
              designerDoc.data() as Map<String, dynamic>?;

          if (designersData != null) {
            List<QueryDocumentSnapshot> docs = a.docs
                .where((element) => element["designerId"] == designerDoc.id)
                .toList();

            if (docs.length < min || min == -1) {
              min = docs.length;
            }
          }
        }

        return min;
      });

      await for (int min in stream) {
        yield BaseSuccess(data: min);
      }
    } catch (e) {
      yield BaseError(message: e.toString());
    }
  }
}
