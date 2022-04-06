import 'package:flutter/material.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/models/StoreModel.dart';
import 'package:deliverytap_user/services/StoreReviewDBService.dart';
import 'package:deliverytap_user/screens/StoreItemsScreen.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class StoreItemComponent extends StatefulWidget {
  final StoreModel? store;
  final String? tag;

  StoreItemComponent({this.store, this.tag});

  @override
  StoreItemComponentState createState() => StoreItemComponentState();
}

class StoreItemComponentState extends State<StoreItemComponent> {
  StoreReviewsDBService? storeReviewsDBService;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await 1.microseconds.delay;

    storeReviewsDBService = StoreReviewsDBService(widget.store!.id);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: context.width(),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: context.scaffoldBackgroundColor,
        boxShadow: defaultBoxShadow(spreadRadius: 0.0, blurRadius: 0.0),
        border: Border.all(color: context.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              cachedImage(
                widget.store!.photoUrl.validate(),
                height: 180,
                width: context.width(),
                fit: BoxFit.cover,
              ).cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.store!.storeName.validate(), style: boldTextStyle(size: 20)),
              Text(
                widget.store!.storeAddress.validate(),
                style: secondaryTextStyle(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ).paddingAll(8),
        ],
      ),
    ).onTap(() {
      hideKeyboard(context);
      StoreItemsScreen(store: widget.store).launch(context);
    }, highlightColor: context.cardColor);
  }
}
