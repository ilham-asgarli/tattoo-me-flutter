import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/core/base/views/base_view.dart';
import 'package:tattoo/core/extensions/string_extension.dart';
import 'package:tattoo/presentation/features/ready/view-models/ready_view_model.dart';
import 'package:tattoo/presentation/features/ready/views/empty_view.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/design-request/design_model.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../widgets/blinking_widget.dart';

class ReadyView extends View<ReadyViewModel> {
  ReadyView({super.key}) : super(viewModelBuilder: () => ReadyViewModel());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BaseResponse<List<DesignModel>>>(
      stream: viewModel.getDesignRequestRepository.getDesignRequestStream(
          context.read<SignBloc>().state.userModel.id ?? ""),
      builder: (context, snapshot) {
        BaseResponse<List<DesignModel>>? baseResponse = snapshot.data;
        if (baseResponse is BaseSuccess<List<DesignModel>>) {
          List<DesignModel>? designModels = baseResponse.data;
          if (designModels != null && designModels.isNotEmpty) {
            return buildImageGrid(designModels);
          } else {
            return const EmptyView();
          }
        } else {
          return const EmptyView();
        }
      },
    );
  }

  GridView buildImageGrid(List<DesignModel> designModels) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: designModels.length,
      itemBuilder: (context, index) {
        DesignModel? designModel = designModels[index];
        int imageIndex = designModel.designResponseImageModels
                ?.indexWhere((element) => element.name == "1") ??
            0;
        imageIndex = imageIndex >= 0 ? imageIndex : 0;

        return InkWell(
          onTap: () {
            RouterService.instance.pushNamed(
              path: RouterConstants.photo,
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              buildImage(
                  designModel.designResponseImageModels?[imageIndex].link ??
                      ""),
              buildRetouching(designModels[index].finished ?? false),
            ],
          ),
        );
      },
    );
  }

  Visibility buildRetouching(bool finished) {
    return Visibility(
      visible: !finished,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
        ),
        child: BlinkingWidget(
          periodDuration: 2,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Image.asset(
              "ic_retouching".toPNG,
              width: 50,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage(String link) {
    return CachedNetworkImage(
      imageUrl: link,
      fit: BoxFit.cover,
    );
  }
}
