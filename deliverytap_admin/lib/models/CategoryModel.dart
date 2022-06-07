import 'package:deliverytap_admin/utils/ModelKeys.dart';

class CategoryModel {
  String? id;
  String? categoryName;
  String? image;
  String? color;
  bool? isDeleted;

  //local
  bool? isCheck;

  CategoryModel({
    this.id,
    this.categoryName,
    this.image,
    this.color,
    this.isDeleted = false,
    this.isCheck = false,
  });

  factory CategoryModel.formJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json[CategoryKey.id],
      categoryName: json[CategoryKey.categoryName],
      image: json[CategoryKey.image],
      color: json[CategoryKey.color],
      isDeleted: json[CategoryKey.isDeleted],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();

    data[CategoryKey.id] = this.id;
    data[CategoryKey.categoryName] = this.categoryName;
    data[CategoryKey.image] = this.image;
    data[CategoryKey.color] = this.color;
    data[CategoryKey.isDeleted] = this.isDeleted;

    return data;
  }
}
