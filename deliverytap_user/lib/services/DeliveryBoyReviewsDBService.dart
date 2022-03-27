import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';

import '../main.dart';
import 'BaseService.dart';

class DeliveryBoyReviewsDBService extends BaseService {
  DeliveryBoyReviewsDBService({String? restId}) {
    ref = db.collection(DELIVERY_BOY_REVIEWS);
  }

  Stream<bool> deliveryBoyReviews({String? orderID}) {
    return ref.where(OrderKeys.orderId, isEqualTo: orderID).limit(1).snapshots().map((value) {
      if (value.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    });
  }
}
