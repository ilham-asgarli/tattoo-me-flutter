import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  StreamSubscription? _subscription;

  NetworkCubit() : super(NetworkInitial()) {
    startCheckConnectivityAndChangeState();
  }

  void startCheckConnectivityAndChangeState() async {
    await firstCheckConnectivityAndChangeState();
    subscribeToConnectivityResultAndChangeState();
  }

  Future<void> firstCheckConnectivityAndChangeState() async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    changeStateByConnectivityResult(result);
  }

  void subscribeToConnectivityResultAndChangeState() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      changeStateByConnectivityResult(result);
    });
  }

  void changeStateByConnectivityResult(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      emit(
        ConnectionFailure(),
      );
    } else {
      emit(
        ConnectionSuccess(
          connectivityResult: result,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
