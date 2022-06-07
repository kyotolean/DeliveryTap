import 'package:deliverytap_user/models/CategoryModel.dart';
import 'package:deliverytap_user/services/BaseService.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';

import '../main.dart';

class CategoryDBService extends BaseService {
  CategoryDBService() {
    ref = db.collection(CATEGORIES);
  }

  Stream<List<CategoryModel>> categories({String searchText = '', isDeleted = false}) {
    return searchText.isNotEmpty
        ? ref.where(StoreKeys.caseSearch, arrayContains: searchText.toLowerCase()) as Stream<List<CategoryModel>>
        : ref.where(CommonKeys.isDeleted, isEqualTo: false).snapshots().map((x) => x.docs.map((y) => CategoryModel.fromJson(y.data() as Map<String, dynamic>)).toList());
  }
}