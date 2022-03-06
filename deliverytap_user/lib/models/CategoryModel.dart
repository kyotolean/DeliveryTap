import 'package:deliverytap_user/utils/ModalKeys.dart';

class CategoryModel {
  String? categoryName;
  String? color;
  String? image;
  String? id;
  bool? isDeleted;

  CategoryModel({this.categoryName, this.color, this.image, this.id, this.isDeleted});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json[CommonKeys.id],
      categoryName: json[CommonKeys.categoryName],
      image: json[CommonKeys.image],
      color: json[CategoryKeys.color],
      isDeleted: json[CommonKeys.isDeleted],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[CommonKeys.categoryName] = this.categoryName;
    data[CommonKeys.image] = this.image;
    data[CategoryKeys.color] = this.color;
    data[CommonKeys.isDeleted] = this.isDeleted;
    return data;
  }
}
