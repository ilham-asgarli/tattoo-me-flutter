import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/models/purchase/past_purchase_model.dart';
import '../../bloc/sign/sign_bloc.dart';
import '../purchase/purchase_cubit.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit(this.context) : super(SubscriptionState()) {
    init();
  }

  final BuildContext context;
  CollectionReference purchases =
      FirebaseFirestore.instance.collection("purchases");
  StreamSubscription<QuerySnapshot<Object?>>? purchaseStream;

  void init() async {
    purchaseStream = purchases
        .where("userId", isEqualTo: context.read<SignBloc>().state.userModel.id)
        .where("type", isEqualTo: "SUBSCRIPTION")
        .where("status", isEqualTo: "ACTIVE")
        .orderBy("purchaseDate", descending: true)
        .snapshots()
        .listen((event) {
      if (event.size > 0) {
        emit(state.copyWith(
          activeSubscriptions: event.docs
              .map(
                (e) => PastPurchaseModel.fromJson(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        ));
      } else {
        emit(state.copyWith(
          activeSubscriptions: [],
        ));

        context.read<PurchaseCubit>().resetPurchases();
        print(
            "purchases from subscriptions: ${context.read<PurchaseCubit>().state.purchases}");
      }
      print("activeSubscriptions: ${state.activeSubscriptions.toString()}");
    });
  }

  Future<PastPurchaseModel?> getLastSubscription(String id) async {
    QuerySnapshot<Object?> subscriptionQuerySnapshot = await purchases
        .where("productId", isEqualTo: id)
        .where("userId", isEqualTo: context.read<SignBloc>().state.userModel.id)
        .where("type", isEqualTo: "SUBSCRIPTION")
        .where("status", isEqualTo: "ACTIVE")
        .orderBy("purchaseDate")
        .limit(1)
        .get();

    if (subscriptionQuerySnapshot.size > 0) {
      return PastPurchaseModel.fromJson(
        subscriptionQuerySnapshot.docs[0].data() as Map<String, dynamic>,
      );
    } else {
      return null;
    }
  }
}
