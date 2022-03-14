import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/StoreModel.dart';
import 'package:deliverytap_admin/services/BaseService.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';

class StoreService extends BaseService {
  StoreService() {
    ref = db.collection(Collect.stores);
  }

  Stream<List<StoreModel>> getAllStores() {
    return ref!.orderBy(StoreKey.isDeleted, descending: false).snapshots().map((event) => event.docs.map((e) => StoreModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }

  Future<StoreModel> getStoreDetails({String? ownerId, bool isDeleted = false}) async {
    return await ref!.where(StoreKey.ownerId, isEqualTo: ownerId).where(StoreKey.isDeleted, isEqualTo: isDeleted).get().then(
          (value) {
        if (value.docs.isNotEmpty) {
          return StoreModel.fromJson(value.docs.first.data() as Map<String, dynamic>);
        } else {
          throw 'Data not found';
        }
      },
    );
  }
}
