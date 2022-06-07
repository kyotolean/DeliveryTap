import 'package:deliverytap_delivery/utils/ModelKey.dart';

class ReviewModel {
  String? id;
  String? deliveryBoyId;
  String? orderId;
  int? rating;
  String? review;
  String? userId;
  String? userImage;
  String? userName;

  ReviewModel({
    this.id,
    this.deliveryBoyId,
    this.orderId,
    this.rating,
    this.review,
    this.userId,
    this.userImage,
    this.userName,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json[CommonKey.id],
      deliveryBoyId: json[ReviewKey.deliveryBoyId],
      orderId: json[ReviewKey.orderId],
      rating: json[ReviewKey.rating],
      review: json[ReviewKey.review],
      userId: json[ReviewKey.userId],
      userImage: json[ReviewKey.userImage],
      userName: json[ReviewKey.userName],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKey.id] = this.id;
    data[ReviewKey.deliveryBoyId] = this.deliveryBoyId;
    data[ReviewKey.orderId] = this.orderId;
    data[ReviewKey.rating] = this.rating;
    data[ReviewKey.review] = this.review;
    data[ReviewKey.userId] = this.userId;
    data[ReviewKey.userImage] = this.userImage;
    data[ReviewKey.userName] = this.userName;
    return data;
  }
}
