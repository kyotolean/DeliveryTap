import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_user/models/CartModel.dart';
import 'package:deliverytap_user/services/BaseService.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';

import '../main.dart';

class ItemDBService extends BaseService {
  ItemDBService() {
    ref = db.collection(ITEMS);
  }

  Stream<List<CartModel>> itemsByStore(String storeId, {String? searchText}) {
    return storesItemsQuery(storeId, searchText: searchText).snapshots().map((x) => x.docs.map((y) => CartModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }

  Query storesItemsQuery(String storeId, {String? searchText}) {
    return ref.where(CommonKeys.storeId, isEqualTo: storeId);
  }

  Stream<List<CartModel>> itemsByCategory(String? catId, {String? searchText}) {
    return ref.where(CommonKeys.categoryId, isEqualTo: catId).snapshots().map((x) => x.docs.map((y) => CartModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }
}
