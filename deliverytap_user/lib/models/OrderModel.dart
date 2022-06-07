import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';

import 'OrderItemData.dart';

class OrderModel {
  List<OrderItemData>? listOfOrder;
  int? totalAmount;
  int? totalItem;
  String? userId;
  String? orderStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? orderId;
  String? storeId;
  String? storeName;
  GeoPoint? userLocation;
  String? userAddress;
  GeoPoint? deliveryBoyLocation;
  String? deliveryBoyId;
  String? paymentMethod;
  String? storeCity;
  String? paymentStatus;
  String? id;
  int?deliveryCharge;

  OrderModel({
    this.listOfOrder,
    this.totalAmount,
    this.totalItem,
    this.userId,
    this.orderStatus,
    this.createdAt,
    this.updatedAt,
    this.orderId,
    this.storeId,
    this.storeName,
    this.userLocation,
    this.userAddress,
    this.deliveryBoyLocation,
    this.deliveryBoyId,
    this.paymentMethod,
    this.storeCity,
    this.paymentStatus,
    this.id,
    this.deliveryCharge,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      listOfOrder: json[OrderKeys.listOfOrder] != null ? (json[OrderKeys.listOfOrder] as List).map<OrderItemData>((e) => OrderItemData.fromJson(e)).toList() : null,
      totalAmount: json[OrderKeys.totalAmount],
      totalItem: json[OrderKeys.totalItem],
      userId: json[OrderKeys.userId],
      orderStatus: json[OrderKeys.orderStatus],
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
      orderId: json[OrderKeys.orderId],
      storeId: json[CommonKeys.storeId],
      storeName: json[StoreKeys.storeName],
      userLocation: json[OrderKeys.userLocation],
      userAddress: json[OrderKeys.userAddress],
      deliveryBoyLocation: json[OrderKeys.deliveryBoyLocation],
      deliveryBoyId: json[OrderKeys.deliveryBoyId],
      paymentMethod: json[OrderKeys.paymentMethod],
      storeCity: json[StoreKeys.storeCity],
      paymentStatus: json[OrderKeys.paymentStatus],
      deliveryCharge: json[OrderKeys.deliveryCharge],
      id: json[CommonKeys.id],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[OrderKeys.listOfOrder] = this.listOfOrder!.map((e) => e.toJson()).toList();

    data[OrderKeys.totalAmount] = this.totalAmount;
    data[OrderKeys.totalItem] = this.totalItem;
    data[OrderKeys.userId] = this.userId;
    data[OrderKeys.orderId] = this.orderId;
    data[OrderKeys.orderStatus] = this.orderStatus;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    data[CommonKeys.storeId] = this.storeId;
    data[StoreKeys.storeName] = this.storeName;
    data[OrderKeys.userLocation] = this.userLocation;
    data[OrderKeys.userAddress] = this.userAddress;
    data[OrderKeys.deliveryBoyLocation] = this.deliveryBoyLocation;
    data[OrderKeys.deliveryBoyId] = this.deliveryBoyId;
    data[OrderKeys.paymentMethod] = this.paymentMethod;
    data[StoreKeys.storeCity] = this.storeCity;
    data[OrderKeys.paymentStatus] = this.paymentStatus;
    data[CommonKeys.id] = this.id;
    data[OrderKeys.deliveryCharge] = this.deliveryCharge;
    return data;
  }
}
