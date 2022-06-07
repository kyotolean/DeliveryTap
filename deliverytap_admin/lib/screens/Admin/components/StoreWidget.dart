import 'package:flutter/material.dart';
import 'package:deliverytap_admin/components/AppWidgets.dart';
import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/StoreModel.dart';
import 'package:deliverytap_admin/screens/Manager/AddStoreDetailScreen.dart';
import 'package:deliverytap_admin/utils/Common.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

class StoreWidget extends StatefulWidget {
  static String tag = '/StoreWidget';
  final StoreModel? data;
  final double? width;

  StoreWidget({this.data, this.width});

  @override
  StoreWidgetState createState() => StoreWidgetState();
}

class StoreWidgetState extends State<StoreWidget> {
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

  Future restDelete({bool? isDelete, String? restId}) async {
    appStore.setLoading(true);
    Map<String, dynamic> data = {
      StoreKey.isDeleted: isDelete,
      TimeDataKey.updatedAt: DateTime.now(),
    };
    await storeService.updateDocument(data, restId).then((value) async {
      //
    }).catchError((error) {
      toast(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: context.isPhone()
            ? widget.width! / 1 - 16
            : context.isTablet()
            ? widget.width! / 3 - 16
            : widget.width! / 4 - 16,
        decoration: boxDecorationWithShadow(
          borderRadius: radius(),
          backgroundColor: context.cardColor,
          shadowColor: shadowColorGlobal,
          spreadRadius: defaultSpreadRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cachedImage(
              widget.data!.photoUrl,
              height: 250,
              width: context.width(),
              fit: BoxFit.fill,
            ).cornerRadiusWithClipRRect(defaultRadius),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                4.height,
                Row(
                  children: [
                    Text('${widget.data!.storeName.validate()}', style: boldTextStyle()).expand(),
                    8.width,
                  ],
                ),
                8.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.pin_drop, size: 18, color: grey),
                    6.width,
                    Text('${widget.data!.storeAddress.validate().capitalizeFirstLetter()}', style: secondaryTextStyle(), maxLines: 2).expand(),
                  ],
                ),
                16.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.call, size: 18, color: grey),
                    12.width,
                    Text('${widget.data!.storeContact.validate().capitalizeFirstLetter()}', style: secondaryTextStyle()),
                  ],
                ),
              ],
            ).center().paddingAll(8),
            8.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.edit, size: 18, color: grey),
                    4.width,
                    Text("Update", style: secondaryTextStyle()),
                  ],
                ).onTap(() async {
                  AddStoreDetailScreen(storeModel: widget.data, isEdit: true).launch(context);
                }),
                12.width,
                Text(!widget.data!.isDeleted! ? "Active" : "Inactive", style: secondaryTextStyle(color: !widget.data!.isDeleted! ? Colors.green : Colors.red)).onTap(() async {
                  bool? res = await showConfirmDialog(
                    context,
                    widget.data!.isDeleted! ? "Are you sure want to active the this store?" : "Are you sure want to Inactive the this store?",
                    positiveText: "Yes",
                    negativeText: "No",
                  );

                  widget.data!.isDeleted = !widget.data!.isDeleted!;
                  if (getBoolAsync(IS_TESTER)) {
                    return toast("Tester role not allowed to perform this action");
                  } else {
                    if (res ?? false) {
                      restDelete(restId: widget.data!.id, isDelete: widget.data!.isDeleted);
                    }
                  }
                }),
              ],
            ).paddingOnly(left: 8, bottom: 8, right: 8),
            16.height,
          ],
        ),
      ).paddingAll(8),
    );
  }
}
