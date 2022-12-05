import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/core/base/view-models/base_view_model.dart';
import 'package:tattoo/domain/models/design-request/design_request_image_model.dart';
import 'package:tattoo/domain/repositories/design-request/implementations/send_design_request_repository.dart';
import 'package:tattoo/utils/logic/state/bloc/sign/sign_bloc.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/design-request/design_model.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../components/progress_dialog.dart';

class TattooChooseViewModel extends BaseViewModel {
  final XFile imageFile;

  TattooChooseViewModel({required this.imageFile});

  SendDesignRequestRepository sendDesignRequestRepository =
      SendDesignRequestRepository();

  final ScreenshotController screenshotController = ScreenshotController();
  XFile? frontImageFile;

  Future<void> onTapSend() async {
    showProgressDialog();

    SignBloc signBloc = context.read<SignBloc>();
    Uint8List? uint8list = await screenshotController.capture();

    if (frontImageFile != null && uint8list != null) {
      List<DesignRequestImageModel> designRequestImageModels = [
        DesignRequestImageModel(image: imageFile.path, name: "1"),
        DesignRequestImageModel(image: frontImageFile!.path, name: "2"),
        DesignRequestImageModel(image: uint8list, name: "3"),
      ];

      BaseResponse<DesignModel> baseResponse =
          await sendDesign(signBloc, designRequestImageModels);

      if (baseResponse is BaseSuccess<DesignModel>) {
        RouterService.instance.pushNamed(
          path: RouterConstants.retouch,
          data: baseResponse.data?.designResponseImageModels?[0].link,
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

  Future<BaseResponse<DesignModel>> sendDesign(SignBloc signBloc,
      List<DesignRequestImageModel> designRequestImageModels) async {
    String? userId = signBloc.state.userModel.id;

    BaseResponse<DesignModel> baseResponse =
        await sendDesignRequestRepository.sendDesignRequest(
      DesignModel(
        userId: userId,
        createdDate: DateTime.now(),
        finished: false,
        designRequestImageModels: designRequestImageModels,
      ),
    );
    return baseResponse;
  }

  void showProgressDialog() {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ProgressDialog();
      },
    );
  }
}
