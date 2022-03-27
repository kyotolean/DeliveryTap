import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/models/StoreModel.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:deliverytap_user/utils/Widgets.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class StoreItemsTopWidget extends StatefulWidget {
  static String tag = '/StoreItemsTopWidget';
  StoreModel? storeData;

  StoreItemsTopWidget({this.storeData});

  @override
  StoreItemsTopWidgetState createState() => StoreItemsTopWidgetState();
}

class StoreItemsTopWidgetState extends State<StoreItemsTopWidget> {
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
    return Stack(
      children: [
        cachedImage(widget.storeData!.photoUrl, width: context.width(), fit: BoxFit.cover, height: 200),
        Container(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0, tileMode: TileMode.mirror),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(widget.storeData!.storeName.toString(), style: boldTextStyle(size: 18, color: Colors.white)).expand(),
                        8.width,
                      ],
                    ).paddingOnly(left: 16, right: 16, top: 16),
                    4.height,
                    Text(
                      widget.storeData!.storeAddress.validate(),
                      style: primaryTextStyle(size: 12, color: Colors.white),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ).paddingOnly(left: 16, right: 16),
                    4.height,
                    Row(
                      children: [
                        Text("Open Hours: ", style: secondaryTextStyle(size: 12, color: Colors.white)),
                        Text(
                          '${widget.storeData!.openTime.validate()} - ${widget.storeData!.closeTime.validate()}',
                          style: primaryTextStyle(size: 12, color: Colors.white),
                        ),
                      ],
                    ).paddingOnly(left: 16, right: 16),
                    4.height,
                    Text(
                      widget.storeData!.storeDesc.validate(),
                      style: secondaryTextStyle(size: 12, color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ).paddingOnly(left: 16, right: 16),
                  ],
                ).expand(),
                cachedImage(widget.storeData!.photoUrl.validate(), fit: BoxFit.cover, height: 100, width: 100).cornerRadiusWithClipRRect(8).paddingRight(16).paddingTop(16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
