import 'package:deliverytap_user/utils/ModalKeys.dart';

class StoreReviewModel {
  String? id;
  String? review;
  int? rating;
  String? reviewerId;
  String? reviewerName;
  String? reviewerImage;
  String? reviewerLocation;
  List<String>? reviewTags;
  String? storeId;

  StoreReviewModel({this.id, this.storeId, this.review, this.rating, this.reviewerId, this.reviewerName, this.reviewerImage, this.reviewerLocation, this.reviewTags});

  factory StoreReviewModel.fromJson(Map<String, dynamic> json) {
    return StoreReviewModel(
      id: json[CommonKeys.id],
      review: json[CommonKeys.review],
      rating: json[CommonKeys.rating],
      reviewerId: json[StoreReviewKeys.reviewerId],
      reviewerName: json[StoreReviewKeys.reviewerName],
      reviewerImage: json[StoreReviewKeys.reviewerImage],
      reviewerLocation: json[StoreReviewKeys.reviewerLocation],
      storeId: json[CommonKeys.storeId],
      reviewTags: json[CommonKeys.reviewTags] != null ? List<String>.from(json[CommonKeys.reviewTags]) : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[CommonKeys.review] = this.review;
    data[CommonKeys.rating] = this.rating;
    data[StoreReviewKeys.reviewerId] = this.reviewerId;
    data[StoreReviewKeys.reviewerName] = this.reviewerName;
    data[StoreReviewKeys.reviewerImage] = this.reviewerImage;
    data[StoreReviewKeys.reviewerLocation] = this.reviewerLocation;
    data[CommonKeys.reviewTags] = this.reviewTags;
    data[CommonKeys.storeId] = this.storeId;
    return data;
  }
}
