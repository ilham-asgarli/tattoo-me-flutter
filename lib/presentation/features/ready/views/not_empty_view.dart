import 'package:flutter/material.dart';
import 'package:tattoo/core/extensions/string_extension.dart';

import '../../../../core/router/core/router_service.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../widgets/blinking_widget.dart';

class NotEmptyView extends StatelessWidget {
  const NotEmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      //itemCount: 3,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            RouterService.instance.pushNamed(
              path: RouterConstants.photo,
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              buildImage(),
              buildRetouching(index == 0),
            ],
          ),
        );
      },
    );
  }

  Visibility buildRetouching(bool isRetouching) {
    return Visibility(
      visible: isRetouching,
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

  Widget buildImage() {
    return Image.network(
      "https://p4.wallpaperbetter.com/wallpaper/747/956/923/5bd129b86d085-wallpaper-preview.jpg",
      fit: BoxFit.cover,
    );
  }
}
