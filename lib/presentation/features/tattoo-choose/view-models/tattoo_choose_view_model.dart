import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../core/base/view-models/base_view_model.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/design-request/design_request_image_model_1.dart';
import '../../../../domain/models/design-request/design_request_model.dart';
import '../../../../domain/repositories/design-requests/implementations/send_design_request_repository.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../components/progress_dialog.dart';

class TattooChooseViewModel extends BaseViewModel {
  final XFile imageFile;

  TattooChooseViewModel({required this.imageFile});

  SendDesignRequestRepository sendDesignRequestRepository =
      SendDesignRequestRepository();

  final ScreenshotController screenshotController = ScreenshotController();
  XFile? frontImageFile;

  Future<void> onTapSend(BuildContext context, bool mounted) async {
    showProgressDialog(context);

    SignBloc signBloc = context.read<SignBloc>();
    Uint8List? uint8list = await screenshotController.capture();

    if (frontImageFile != null && uint8list != null) {
      List<DesignRequestImageModel1> designRequestImageModels = [
        DesignRequestImageModel1(image: imageFile.path, name: "1"),
        DesignRequestImageModel1(image: frontImageFile!.path, name: "2"),
        DesignRequestImageModel1(image: uint8list, name: "3"),
      ];

      BaseResponse<DesignRequestModel> baseResponse =
          await sendDesign(signBloc, designRequestImageModels);

      if (baseResponse is BaseSuccess<DesignRequestModel>) {
        RouterService.instance.pushNamed(
          path: RouterConstants.retouch,
          data: baseResponse.data,
        );
      } else {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<BaseResponse<DesignRequestModel>> sendDesign(SignBloc signBloc,
      List<DesignRequestImageModel1> designRequestImageModels) async {
    String? userId = signBloc.state.userModel.id;

    BaseResponse<DesignRequestModel> baseResponse =
        await sendDesignRequestRepository.sendDesignRequest(
      DesignRequestModel(
        userId: userId,
        createdDate: DateTime.now(),
        finished: false,
        designRequestImageModels1: designRequestImageModels,
      ),
    );
    return baseResponse;
  }

  void showProgressDialog(context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ProgressDialog();
      },
    );
  }
}
