import 'package:deliverytap_user/models/CartModel.dart';
import 'package:deliverytap_user/utils/Constants.dart';

import '../main.dart';
import 'BaseService.dart';

class MyCartDBService extends BaseService {
  MyCartDBService() {
    ref = db.collection(USERS).doc(appStore.userId).collection(CART);
  }

  Stream<List<CartModel>> cartList() {
    return ref.snapshots().map((x) => x.docs.map((y) => CartModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }

  Future<List<CartModel>> getCartList() async {
    return await ref.get().then((x) => x.docs.map((y) => CartModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }
}
