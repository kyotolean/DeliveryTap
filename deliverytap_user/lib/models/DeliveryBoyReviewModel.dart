import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';

class DeliveryBoyReviewModel {
  String? id;
  String? review;
  int? rating;
  String? userId;
  String? userName;
  String? userImage;
  List<String>? reviewTags;
  String? deliveryBoyId;
  String? orderId;
  DateTime? createdAt;
  DateTime? updatedAt;

  DeliveryBoyReviewModel({
    this.id,
    this.review,
    this.rating,
    this.userId,
    this.userName,
    this.userImage,
    this.reviewTags,
    this.deliveryBoyId,
    this.orderId,
    this.createdAt,
    this.updatedAt,
  });

  factory DeliveryBoyReviewModel.fromJson(Map<String, dynamic> json) {
    return DeliveryBoyReviewModel(
      id: json[CommonKeys.id],
      review: json[CommonKeys.review],
      rating: json[CommonKeys.rating],
      userId: json[OrderKeys.userId],
      userName: json[DeliveryBoyReviewKeys.userName],
      userImage: json[DeliveryBoyReviewKeys.userImage],
      reviewTags: json[CommonKeys.reviewTags] != null ? List<String>.from(json[CommonKeys.reviewTags]) : [],
      deliveryBoyId: json[OrderKeys.deliveryBoyId],
      orderId: json[OrderKeys.orderId],
      createdAt: json[CommonKeys.createdAt] != null ? (json[CommonKeys.createdAt] as Timestamp).toDate() : null,
      updatedAt: json[CommonKeys.updatedAt] != null ? (json[CommonKeys.updatedAt] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[CommonKeys.review] = this.review;
    data[CommonKeys.rating] = this.rating;
    data[DeliveryBoyReviewKeys.userId] = this.userId;
    data[DeliveryBoyReviewKeys.userName] = this.userName;
    data[DeliveryBoyReviewKeys.userImage] = this.userImage;
    data[CommonKeys.reviewTags] = this.reviewTags;
    data[OrderKeys.deliveryBoyId] = this.deliveryBoyId;
    data[OrderKeys.orderId] = this.orderId;
    data[CommonKeys.createdAt] = this.createdAt;
    data[CommonKeys.updatedAt] = this.updatedAt;
    return data;
  }
}
