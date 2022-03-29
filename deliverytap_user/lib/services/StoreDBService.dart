import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_user/models/StoreModel.dart';
import 'package:deliverytap_user/services/BaseService.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class StoreDBService extends BaseService {
  StoreDBService() {
    ref = db.collection(STORES);
  }

  Stream<List<StoreModel>> stores({required String searchText}) {
    return storesQuery(searchText: searchText).snapshots().map((x) => x.docs.map((y) => StoreModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }
/*
  Query storesQuery({String searchText = ''}) {
    return searchText.isNotEmpty
        ? ref.where(StoreKeys.caseSearch, arrayContains: searchText.toLowerCase()).where(StoreKeys.storeCity, isEqualTo: getStringAsync(USER_CITY_NAME)).where(CommonKeys.isDeleted, isEqualTo: false)
        : ref.where(StoreKeys.storeCity, isEqualTo: getStringAsync(USER_CITY_NAME)).where(CommonKeys.isDeleted, isEqualTo: false);
  }
*/
  Query storesQuery({String searchText = ''}) {
    return searchText.isNotEmpty
        ? ref.where(StoreKeys.caseSearch, arrayContains: searchText.toLowerCase()).where(CommonKeys.isDeleted, isEqualTo: false)
        : ref.where(CommonKeys.isDeleted, isEqualTo: false);
  }

  Stream<List<StoreModel>> storeByCategory(String? categoryName, {String? searchText, String? cityName}) {
    return ref
        .where(StoreKeys.catList, arrayContains: categoryName)
        .where(StoreKeys.storeCity, isEqualTo: cityName)
        .where(CommonKeys.isDeleted, isEqualTo: false)
        .snapshots()
        .map((x) => x.docs.map((y) => StoreModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }

  Future<StoreModel> getStoreById({String? storeId}) async {
    return await ref.where(CommonKeys.id, isEqualTo: storeId).get().then((res) {
      if (res.docs.isEmpty) {
        throw "No Restaurant Found";
      } else {
        return StoreModel.fromJson(res.docs.first.data() as Map<String, dynamic>);
      }
    }).catchError((error) {
      throw error.toString();
    });
  }
}
