import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/model/StoreModel.dart';
import 'package:deliverytap_delivery/services/BaseService.dart';
import 'package:deliverytap_delivery/utils/ModelKey.dart';

class StoreService extends BaseService {
  StoreService() {
    ref = db.collection('stores');
  }

  Future<StoreModel> getStoreById({String? storeId}) async {
    return await ref.where(CommonKey.id, isEqualTo: storeId).get().then((str) {
      if (str.docs.isEmpty) {
        throw 'Stores not found';
      } else {
        return StoreModel.fromJson(str.docs.first.data() as Map<String, dynamic>);
      }
    }).catchError((error) {
      throw error.toString();
    });
  }
}
