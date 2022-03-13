import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_delivery/utils/ModelKey.dart';

class OrderModel {
  String? id;
  DateTime? createdAt;
  int? number;
  List<OrderItems>? orderItems;
  int? totalAmount;
  String? restaurantId;
  String? deliveryBoyId;
  String? userId;
  String? orderStatus;
  String? userAddress;
  GeoPoint? userLocation;
  GeoPoint? deliveryBoyLocation;
  String? paymentMethod;
  String? paymentStatus;
  String? restaurantCity;
  String? orderId;
  int? deliveryCharge;
  String? restaurantName;

  OrderModel({
    this.id,
    this.createdAt,
    this.number,
    this.orderItems,
    this.totalAmount,
    this.restaurantId,
    this.userId,
    this.orderStatus,
    this.userLocation,
    this.deliveryBoyLocation,
    this.userAddress,
    this.paymentMethod,
    this.paymentStatus,
    this.restaurantCity,
    this.deliveryBoyId,
    this.orderId,
    this.deliveryCharge,
    this.restaurantName,
  });


  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json[CommonKey.id],
      createdAt: json[CommonKey.createdAt] != null ? (json[CommonKey.createdAt] as Timestamp).toDate() : null,
      number: json[OrderKey.number],
      orderItems: json[OrderKey.orderItems] != null ? (json[OrderKey.orderItems] as List).map((i) => OrderItems.fromJson(i)).toList() : null,
      totalAmount: json[OrderKey.totalAmount],
      restaurantId: json[OrderKey.restaurantId],
      userId: json[OrderKey.userId],
      orderStatus: json[OrderKey.orderStatus],
      userLocation: json[OrderKey.userLocation],
      deliveryBoyLocation: json[OrderKey.deliveryBoyLocation],
      userAddress: json[OrderKey.userAddress],
      paymentMethod: json[OrderKey.paymentMethod],
      paymentStatus: json[OrderKey.paymentStatus],
      restaurantCity: json[OrderKey.restaurantCity],
      deliveryBoyId: json[OrderKey.deliveryBoyId],
      orderId: json[OrderKey.orderId],
      deliveryCharge: json[OrderKey.deliveryCharge],
      restaurantName: json[OrderKey.restaurantName],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKey.id] = this.id;
    data[CommonKey.createdAt] = this.createdAt;
    data[OrderKey.number] = this.number;
    data[OrderKey.totalAmount] = this.totalAmount;
    data[OrderKey.restaurantId] = this.restaurantId;
    data[OrderKey.userId] = this.userId;
    data[OrderKey.orderStatus] = this.orderStatus;
    data[OrderKey.userLocation] = this.userLocation;
    data[OrderKey.deliveryBoyLocation] = this.deliveryBoyLocation;
    data[OrderKey.userAddress] = this.userAddress;
    data[OrderKey.paymentMethod] = this.paymentMethod;
    data[OrderKey.paymentStatus] = this.paymentStatus;
    data[OrderKey.deliveryBoyId] = this.deliveryBoyId;
    data[OrderKey.restaurantCity] = this.restaurantCity;
    data[OrderKey.orderId] = this.orderId;
    data[OrderKey.deliveryCharge] = this.deliveryCharge;
    data[OrderKey.restaurantName] = this.restaurantName;
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
