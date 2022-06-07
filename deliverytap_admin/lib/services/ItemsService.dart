import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/ItemsModel.dart';
import 'package:deliverytap_admin/services/BaseService.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';

class ItemsService extends BaseService {
  ItemsService() {
    ref = db.collection(Collect.items);
  }

  Stream<List<ItemsModel>> getItemsData({String? storeId}) {
    return ref!.where(ItemKey.storeId, isEqualTo: storeId).snapshots().map((event) => event.docs.map((e) => ItemsModel.fromJson(e.data() as Map<String, dynamic>)).toList());
  }
}
