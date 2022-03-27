import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';

class CartModel {
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

  //local
  int? qty;
  bool? isCheck;

  CartModel({
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
    this.qty = 1,
    this.isDeleted,
    this.isCheck= false,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json[CommonKeys.id],
      itemName: json[CommonKeys.itemName],
      image: json[CommonKeys.image],
      itemPrice: json[CommonKeys.itemPrice],
      inStock: json[CartKeys.inStock],
      categoryId: json[CommonKeys.categoryId],
      categoryName: json[CommonKeys.categoryName],
      description: json[CartKeys.description],
      storeId: json[CartKeys.storeId],
      qty: json['qty'] != null ? json['qty'] : 1,
      storeName: json[StoreKeys.storeName],
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
      isDeleted: json[CommonKeys.isDeleted],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[CommonKeys.itemName] = this.itemName;
    data[CommonKeys.image] = this.image;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    data[CommonKeys.itemPrice] = this.itemPrice;
    data[CartKeys.inStock] = this.inStock;
    data[CommonKeys.categoryId] = this.categoryId;
    data[CommonKeys.categoryName] = this.categoryName;
    data[CartKeys.description] = this.description;
    data[CartKeys.storeId] = this.storeId;
    data[StoreKeys.storeName] = this.storeName;
    data[CommonKeys.isDeleted] = this.isDeleted;
    data['qty'] = this.qty;
    return data;
  }
}
