import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/CategoryModel.dart';
import 'package:deliverytap_admin/services/BaseService.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';

class CategoryService extends BaseService {
  CategoryService() {
    ref = db.collection(Collect.categories);
  }

  Stream<List<CategoryModel>> getCategory({bool showDeletedItem = true}) {
    return showDeletedItem
        ? ref!.orderBy(CategoryKey.isDeleted, descending: false).snapshots().map((event) => event.docs.map((e) => CategoryModel.formJson(e.data() as Map<String, dynamic>)).toList())
        : ref!.where(CategoryKey.isDeleted, isEqualTo: false).snapshots().map((event) => event.docs.map((e) => CategoryModel.formJson(e.data() as Map<String, dynamic>)).toList());
  }

  Future<CategoryModel> getCategoryDetails({String? catId, bool isDeleted = false}) async {
    return ref!.where('id', isEqualTo: catId).where(StoreKey.isDeleted, isEqualTo: isDeleted).get().then((value) {
      if (value.docs.isNotEmpty) {
        return CategoryModel.formJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'Category not found';
      }
    });
  }
}
