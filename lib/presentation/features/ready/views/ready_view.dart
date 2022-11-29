import 'package:flutter/material.dart';

import 'empty_view.dart';
import 'not_empty_view.dart';

class ReadyView extends StatefulWidget {
  const ReadyView({Key? key}) : super(key: key);

  @override
  State<ReadyView> createState() => _ReadyViewState();
}

class _ReadyViewState extends State<ReadyView> {
  bool isFirst = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isFirst ? const EmptyView() : const NotEmptyView(),
    );
  }
}
