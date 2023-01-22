import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/design-request/design_request_model.dart';
import '../../../../domain/models/design-response/design_response_model.dart';
import '../../../../domain/repositories/design-requests/implementations/send_design_request_repository.dart';
import '../../../../utils/logic/constants/enums/app_enum.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/state/bloc/retouch-alert/retouch_alert_bloc.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../../utils/ui/validators/retouch_comment_validator.dart';

class RetouchAlert extends StatefulWidget {
  final DesignResponseModel designModel;

  const RetouchAlert({required this.designModel, Key? key}) : super(key: key);

  @override
  State<RetouchAlert> createState() => _RetouchAlertState();
}

class _RetouchAlertState extends State<RetouchAlert> {
  final alertKey = UniqueKey();
  final GlobalKey<FormState> _retouchFormKey = GlobalKey<FormState>();
  String? comment;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: alertKey,
      backgroundColor: HexColor("#e6e6e6"),
      titlePadding: const EdgeInsets.all(5),
      actionsPadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      actionsAlignment: MainAxisAlignment.center,
      title: buildTitle(context),
      actions: buildActions(context),
      content: buildContent(),
    );
  }

  Row? buildTitle(BuildContext context) {
    return context.watch<RetouchAlertBloc>().state.retouchSendingState ==
            RetouchSendingState.sent
        ? null
        : Row(
            children: [
              InkWell(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ],
          );
  }

  Widget buildContent() {
    return Form(
      key: _retouchFormKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible:
                  context.watch<RetouchAlertBloc>().state.retouchSendingState !=
                      RetouchSendingState.sent,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  LocaleKeys.retouchAlertTitle.tr(),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            Card(
              elevation: 0,
              color: Colors.white,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: context
                            .watch<RetouchAlertBloc>()
                            .state
                            .retouchSendingState ==
                        RetouchSendingState.sent
                    ? FittedBox(
                        child: Text(
                          LocaleKeys.sentForRetouch.tr(),
                          style: const TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : TextFormField(
                        minLines: 5,
                        maxLines: 5,
                        cursorColor: Colors.black,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: LocaleKeys.writeNoteHere.tr(),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        onSaved: (String? value) {
                          comment = value;
                        },
                        validator: (value) {
                          return RetouchCommentValidator(value).validate();
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildActions(BuildContext context) {
    return [
      Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                ),
                onPressed: () async {
                  if (context
                          .read<RetouchAlertBloc>()
                          .state
                          .retouchSendingState ==
                      RetouchSendingState.sent) {
                    Navigator.pop(context);
                    return;
                  }

                  if (_retouchFormKey.currentState!.validate()) {
                    _retouchFormKey.currentState?.save();

                    FocusManager.instance.primaryFocus?.unfocus();
                    BlocProvider.of<RetouchAlertBloc>(context)
                        .add(StartRetouchSending());

                    if (comment != null) {
                      BaseResponse<DesignRequestModel> baseResponse =
                          await sendDesignRetouch(comment!);
                      if (mounted) {
                        BlocProvider.of<RetouchAlertBloc>(context)
                            .add(EndRetouchSending());
                      }
                    }
                  }
                },
                child: (context
                            .watch<RetouchAlertBloc>()
                            .state
                            .retouchSendingState ==
                        RetouchSendingState.sending)
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            HexColor("#666666"),
                          ),
                        ),
                      )
                    : Text(
                        context
                                    .watch<RetouchAlertBloc>()
                                    .state
                                    .retouchSendingState ==
                                RetouchSendingState.sent
                            ? LocaleKeys.close.tr()
                            : LocaleKeys.send.tr(),
                      ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Future<BaseResponse<DesignRequestModel>> sendDesignRetouch(
      String comment) async {
    SendDesignRequestRepository sendDesignRequestRepository =
        SendDesignRequestRepository();
    String? userId = context.read<SignBloc>().state.userModel.id;

    BaseResponse<DesignRequestModel> baseResponse =
        await sendDesignRequestRepository.sendRetouchDesignRequest(
      DesignRequestModel(
        id: widget.designModel.id,
        userId: userId,
        finished: false,
        previousRequestId: widget.designModel.requestId,
        designerId: widget.designModel.designerId,
      ),
      comment,
    );
    return baseResponse;
  }
}
