import 'package:deliverytap_user/utils/ModalKeys.dart';

class OrderItemData {
  String? id;
  String? categoryId;
  String? categoryName;
  String? image;
  String? itemName;
  int? itemPrice;
  int? qty;
  String? storeId;
  String? storeName;

  OrderItemData({
    this.id,
    this.categoryId,
    this.categoryName,
    this.image,
    this.itemName,
    this.itemPrice,
    this.qty,
    this.storeId,
    this.storeName,
  });

  factory OrderItemData.fromJson(Map<String, dynamic> json) {
    return OrderItemData(
      id: json[CommonKeys.id],
      image: json[CommonKeys.image],
      itemName: json[CommonKeys.itemName],
      itemPrice: json[CommonKeys.itemPrice],
      categoryId: json[CommonKeys.categoryId],
      categoryName: json[CommonKeys.categoryName],
      qty: json[CommonKeys.qty],
      storeId: json[CommonKeys.storeId],
      storeName: json[StoreKeys.storeName],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[CommonKeys.itemName] = this.itemName;
    data[CommonKeys.image] = this.image;
    data[CommonKeys.itemPrice] = this.itemPrice;
    data[CommonKeys.categoryId] = this.categoryId;
    data[CommonKeys.categoryName] = this.categoryName;
    data[CommonKeys.qty] = this.qty;
    data[CommonKeys.storeId] = this.storeId;
    data[StoreKeys.storeName] = this.storeName;
    return data;
  }
}
