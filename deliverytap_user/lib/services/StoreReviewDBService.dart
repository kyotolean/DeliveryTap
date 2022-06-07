import 'package:deliverytap_user/models/StoreReviewModel.dart';
import 'package:deliverytap_user/services/BaseService.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';

import '../main.dart';

class StoreReviewsDBService extends BaseService {
  StoreReviewsDBService(String? restId) {
    ref = db.collection(STORE_REVIEWS);
  }

  Stream<List<StoreReviewModel>> reviews(String? storeId) {
    return ref.where(CommonKeys.storeId, isEqualTo: storeId).snapshots().map((x) => x.docs.map((y) => StoreReviewModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }
}
