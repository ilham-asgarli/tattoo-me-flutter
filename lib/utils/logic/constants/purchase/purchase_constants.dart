import '../../helpers/purchase/purchase_helper.dart';
import '../enums/purchase_enums.dart';

class PurchaseConstants {
  static List<String> all = [
    ...PurchaseHelper.instance.getAllIds(Purchase.inAppProduct),
    ...PurchaseHelper.instance.getAllIds(Purchase.subscription),
  ];
}
