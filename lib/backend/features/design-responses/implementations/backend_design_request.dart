import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/backend/models/design-responses/backend_design_response_model.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/design-response/design_response_model.dart';

import '../../../../core/base/models/base_response.dart';
import '../interfaces/backend_design_request_interface.dart';

class BackendDesignResponse extends BackendDesignResponseInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference designResponses =
      FirebaseFirestore.instance.collection("design-responses");

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
}
