import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/OrderModel.dart';
import 'package:deliverytap_admin/services/BaseService.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderService extends BaseService {
  OrderService() {
    ref = db.collection(Collect.orders);
  }

  Stream<List<OrderModel>> getOrders({String? id, List<String>? orderStatus, bool isDash = false}) {
    Query query;

    if (getBoolAsync(IS_ADMIN) && isDash) {
      query = ref!.where(OrderKey.orderStatus, whereIn: orderStatus).orderBy(TimeDataKey.createdAt, descending: true).limit(10);
    } else if (getBoolAsync(IS_ADMIN)) {
      query = ref!.where(OrderKey.orderStatus, whereIn: orderStatus).orderBy(TimeDataKey.createdAt, descending: true);
    } else {
      query = ref!.where(OrderKey.storeId, isEqualTo: id).where(OrderKey.orderStatus, whereIn: orderStatus).orderBy(TimeDataKey.createdAt, descending: true);
    }
    return query.snapshots().map((event) => event.docs.map((e) => OrderModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }

  Stream<List<OrderModel>> restaurantTotalAmount({DateTime? startDate}) {
    return ref!
        .where(OrderKey.storeId, isEqualTo: getStringAsync(STORE_ID))
        .where(TimeDataKey.createdAt, isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: DateTime.now())
        .where(OrderKey.orderStatus, isEqualTo: COMPLETED)
        .snapshots()
        .map((x) {
      return x.docs.map((y) => OrderModel.fromJson(y.data() as Map<String, dynamic>)).toList();
    });
  }
}
