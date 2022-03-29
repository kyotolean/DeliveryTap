import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';

class ItemsModel {
  String? id;
  String? itemName;
  int? itemPrice;
  bool? inStock;
  String? categoryId;
  String? storeId;
  String? storeName;
  String? categoryName;
  String? image;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isDeleted;

  DocumentReference? restRef;

  ItemsModel({
    this.itemName,
    this.id,
    this.image,
    this.itemPrice,
    this.inStock,
    this.categoryId,
    this.categoryName,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.storeId,
    this.storeName,
    this.isDeleted,
  });

  factory ItemsModel.fromJson(Map<String, dynamic> json) {
    return ItemsModel(
      id: json[ItemKey.id],
      itemName: json[ItemKey.itemName],
      image: json[ItemKey.image],
      itemPrice: json[ItemKey.itemPrice],
      inStock: json[ItemKey.inStock],
      categoryId: json[ItemKey.categoryId],
      categoryName: json[ItemKey.categoryName],
      description: json[ItemKey.description],
      storeId: json[ItemKey.storeId],
      storeName: json[ItemKey.storeName],
      createdAt: json[TimeDataKey.createdAt] != null ? (json[TimeDataKey.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[TimeDataKey.updatedAt] != null ? (json[TimeDataKey.updatedAt] as Timestamp).toDate() : null,
      isDeleted: json[ItemKey.isDeleted],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[ItemKey.id] = this.id;
    data[ItemKey.itemName] = this.itemName;
    data[ItemKey.image] = this.image;
    data[ItemKey.itemPrice] = this.itemPrice;
    data[ItemKey.inStock] = this.inStock;
    data[ItemKey.categoryId] = this.categoryId;
    data[ItemKey.categoryName] = this.categoryName;
    data[ItemKey.description] = this.description;
    data[ItemKey.storeId] = this.storeId;
    data[ItemKey.storeName] = this.storeName;
    data[TimeDataKey.createdAt] = this.createdAt;
    data[TimeDataKey.updatedAt] = this.updatedAt;
    data[ItemKey.isDeleted] = this.isDeleted;
    return data;
  }
}
