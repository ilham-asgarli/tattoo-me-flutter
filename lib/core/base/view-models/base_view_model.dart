import 'package:flutter/widgets.dart';

import '../views/base_view.dart';

abstract class BaseViewModel extends ChangeNotifier {
  //@protected
  late void Function() buildView;
  late View<BaseViewModel> widget;
  late BuildContext context;
  late bool mounted;

  //@protected
  @mustCallSuper
  void initState() {}
}
