import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../view-models/base_view_model.dart';

abstract class View<T extends BaseViewModel> extends StatefulWidget {
  View({
    required this.viewModelBuilder,
    super.key,
  });

  final T Function() viewModelBuilder;
  final _viewModelInstance = _ViewModelInstance<T>();

  T get viewModel => _viewModelInstance.value!;

  Widget build(BuildContext context);

  @nonVirtual
  @override
  State<View<T>> createState() => _ViewState<T>();
}

class _ViewState<T extends BaseViewModel> extends State<View<T>> {
  late T _viewModel;

  @override
  void initState() {
    super.initState();
    _initViewModel();
    _viewModel.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _initViewModel() {
    _viewModel = widget.viewModelBuilder();
    _viewModel.buildView = () => setState(() {});
    _viewModel.addListener(_viewModel.buildView);

    _viewModel.widget = widget;
    _viewModel.context = context;
    _viewModel.mounted = mounted;
  }

  @override
  Widget build(BuildContext context) {
    widget._viewModelInstance.value = _viewModel;
    return widget.build(context);
  }
}

class _ViewModelInstance<T> {
  T? value;
}
