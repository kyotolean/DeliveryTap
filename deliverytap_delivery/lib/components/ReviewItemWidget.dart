import 'package:flutter/material.dart';
import 'package:deliverytap_delivery/model/ReviewModel.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewItemWidget extends StatefulWidget {
  final ReviewModel? reviewModel;
  final int? ratings;

  ReviewItemWidget({this.reviewModel, this.ratings});

  @override
  ReviewItemWidgetState createState() => ReviewItemWidgetState();
}

class ReviewItemWidgetState extends State<ReviewItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: boxDecorationRoundedWithShadow(12, backgroundColor: context.cardColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.reviewModel!.userImage!.isNotEmpty
              ? commonCachedNetworkImage(
            widget.reviewModel!.userImage,
            fit: BoxFit.cover,
            width: 50,
            height: 50,
          ).cornerRadiusWithClipRRect(25)
              : Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: grayColor.withOpacity(0.2)),
            height: 50,
            width: 50,
            child: Icon(Icons.person, size: 35),
          ),
          8.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.reviewModel!.userName!, style: boldTextStyle()),
              4.height,
              Row(
                children: List.generate(5, (index) {
                  if (index < widget.ratings!) {
                    return Icon(Icons.star, color: Colors.yellow, size: 10);
                  } else {
                    return Icon(Icons.star_border, color: Colors.yellow, size: 10);
                  }
                }),
              ),
              8.height,
              Text(
                widget.reviewModel!.review!,
                style: primaryTextStyle(size: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ).expand(),
        ],
      ),
    );
  }
}
