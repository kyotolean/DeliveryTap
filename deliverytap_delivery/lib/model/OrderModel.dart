import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_delivery/utils/ModelKey.dart';

class OrderModel {
  String? id;
  DateTime? createdAt;
  int? number;
  List<OrderItems>? orderItems;
  int? totalAmount;
  String? storeId;
  String? deliveryBoyId;
  String? userId;
  String? orderStatus;
  String? userAddress;
  GeoPoint? userLocation;
  GeoPoint? deliveryBoyLocation;
  String? paymentMethod;
  String? paymentStatus;
  String? storeCity;
  String? orderId;
  int? deliveryCharge;
  String? storeName;

  OrderModel({
    this.id,
    this.createdAt,
    this.number,
    this.orderItems,
    this.totalAmount,
    this.storeId,
    this.userId,
    this.orderStatus,
    this.userLocation,
    this.deliveryBoyLocation,
    this.userAddress,
    this.paymentMethod,
    this.paymentStatus,
    this.storeCity,
    this.deliveryBoyId,
    this.orderId,
    this.deliveryCharge,
    this.storeName,
  });


  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json[CommonKey.id],
      createdAt: json[CommonKey.createdAt] != null ? (json[CommonKey.createdAt] as Timestamp).toDate() : null,
      number: json[OrderKey.number],
      orderItems: json[OrderKey.orderItems] != null ? (json[OrderKey.orderItems] as List).map((i) => OrderItems.fromJson(i)).toList() : null,
      totalAmount: json[OrderKey.totalAmount],
      storeId: json[OrderKey.storeId],
      userId: json[OrderKey.userId],
      orderStatus: json[OrderKey.orderStatus],
      userLocation: json[OrderKey.userLocation],
      deliveryBoyLocation: json[OrderKey.deliveryBoyLocation],
      userAddress: json[OrderKey.userAddress],
      paymentMethod: json[OrderKey.paymentMethod],
      paymentStatus: json[OrderKey.paymentStatus],
      storeCity: json[OrderKey.storeCity],
      deliveryBoyId: json[OrderKey.deliveryBoyId],
      orderId: json[OrderKey.orderId],
      deliveryCharge: json[OrderKey.deliveryCharge],
      storeName: json[OrderKey.storeName],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKey.id] = this.id;
    data[CommonKey.createdAt] = this.createdAt;
    data[OrderKey.number] = this.number;
    data[OrderKey.totalAmount] = this.totalAmount;
    data[OrderKey.storeId] = this.storeId;
    data[OrderKey.userId] = this.userId;
    data[OrderKey.orderStatus] = this.orderStatus;
    data[OrderKey.userLocation] = this.userLocation;
    data[OrderKey.deliveryBoyLocation] = this.deliveryBoyLocation;
    data[OrderKey.userAddress] = this.userAddress;
    data[OrderKey.paymentMethod] = this.paymentMethod;
    data[OrderKey.paymentStatus] = this.paymentStatus;
    data[OrderKey.deliveryBoyId] = this.deliveryBoyId;
    data[OrderKey.storeCity] = this.storeCity;
    data[OrderKey.orderId] = this.orderId;
    data[OrderKey.deliveryCharge] = this.deliveryCharge;
    data[OrderKey.storeName] = this.storeName;
    if (this.orderItems != null) {
      data[OrderKey.orderItems] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class OrderItems {
  String? itemName;
  String? image;
  int? itemPrice;
  int? qty;

  OrderItems({this.itemName, this.image, this.qty, this.itemPrice});

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return OrderItems(
      itemName: json[OrderItemsKey.itemName],
      image: json[OrderItemsKey.image],
      qty: json[OrderItemsKey.qty],
      itemPrice: json[OrderItemsKey.itemPrice],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[OrderItemsKey.itemName] = this.itemName;
    data[OrderItemsKey.image] = this.image;
    data[OrderItemsKey.qty] = this.qty;
    data[OrderItemsKey.itemPrice] = this.itemPrice;
    return data;
  }
}
