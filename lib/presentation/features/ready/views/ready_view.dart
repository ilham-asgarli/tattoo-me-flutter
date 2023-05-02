import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../domain/models/design-request/design_request_model.dart';
import '../../../../domain/models/design-response/design_response_model.dart';
import '../../../../domain/repositories/design-responses/implementations/design_responses_repository.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../../utils/logic/state/cubit/ready/ready_cubit.dart';
import '../../../widgets/blinking_widget.dart';
import '../view-models/ready_view_model.dart';
import 'empty_view.dart';

class ReadyView extends StatefulWidget {
  const ReadyView({Key? key}) : super(key: key);

  @override
  State<ReadyView> createState() => _ReadyViewState();
}

class _ReadyViewState extends State<ReadyView> {
  ReadyViewModel viewModel = ReadyViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SignBloc, SignState>(
        builder: (context, signState) {
          return BlocBuilder<ReadyCubit, ReadyState>(
            builder: (context, readyState) {
              return buildStream(signState);
            },
          );
        },
      ),
    );
  }

  Widget buildStream(SignState signState) {
    return StreamBuilder<BaseResponse<List<DesignResponseModel>>>(
      stream: viewModel.getDesignResponseRepository
          .getDesignResponseStream(signState.userModel.id ?? ""),
      builder: (context, snapshot) {
        BaseResponse<List<DesignResponseModel>>? baseResponse = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(
                HexColor("#666666"),
              ),
            ),
          );
        }

        if (baseResponse is BaseSuccess<List<DesignResponseModel>>) {
          List<DesignResponseModel>? designModels = baseResponse.data;
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

  GridView buildImageGrid(List<DesignResponseModel> designModels) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: designModels.length,
      itemBuilder: (context, index) {
        return buildImageGridItem(
          designModels,
          index,
        );
      },
    );
  }

  Widget buildImageGridItem(List<DesignResponseModel> designModels, int index) {
    DesignRequestModel? designRequestModel =
        designModels[index].designRequestModel;
    int imageIndex = designRequestModel?.designRequestImageModels2
            ?.indexWhere((element) => element.name == "1") ??
        0;
    imageIndex = imageIndex >= 0 ? imageIndex : 0;

    return InkWell(
      onTap: () async {
        await viewModel.onTapImage(
          context,
          designRequestModel,
          designModels,
          index,
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          !(designRequestModel?.finished ?? false)
              ? buildImage(designRequestModel
                      ?.designRequestImageModels2?[imageIndex].link ??
                  "")
              : buildResponseImage(
                  designRequestModel
                          ?.designRequestImageModels2?[imageIndex].link ??
                      "",
                  designRequestModel?.id ?? ""),
          buildNotBought(),
          buildRetouching(designRequestModel?.finished ?? false),
        ],
      ),
    );
  }

  Widget buildNotBought() {
    return Visibility(
      visible: !(context.read<SignBloc>().state.userModel.isBoughtFirstDesign ??
          false),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3,
            sigmaY: 3,
          ),
          child: const SizedBox(),
        ),
      ),
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

  Widget buildResponseImage(String link, String requestId) {
    DesignResponseRepository designResponseRepository =
        DesignResponseRepository();

    return FutureBuilder<BaseResponse<DesignResponseModel>>(
      future: designResponseRepository.getDesignResponse(requestId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          BaseResponse<DesignResponseModel>? baseResponse = snapshot.data;

          if (baseResponse is BaseSuccess<DesignResponseModel>) {
            return buildImage(baseResponse.data?.imageLink ?? "");
          }
        }

        return buildImage(link);
      },
    );
  }
}
