import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:deliverytap_admin/components/AppWidgets.dart';
import 'package:deliverytap_admin/models/StoreModel.dart';
import 'package:deliverytap_admin/utils/Colors.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'AddStoreDetailScreen.dart';

class StoreDetailScreen extends StatefulWidget {
  static String tag = '/StoreDetailScreen';

  @override
  StoreDetailScreenState createState() => StoreDetailScreenState();
}

class StoreDetailScreenState extends State<StoreDetailScreen> {
  StoreModel? storeModel = StoreModel();

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
    return Scaffold(
      appBar: appBarWidget(
        'Restaurant Details',
        showBack: false,
        elevation: 0,
        actions: [
          Icon(Icons.edit_outlined, color: colorPrimary)
              .onTap(() async {
            await AddStoreDetailScreen(storeModel: storeModel).launch(context);
            setState(() {});
          })
              .paddingRight(16)
              .visible(storeModel != null)
        ],
      ),
      body: Container(
        child: FutureBuilder<StoreModel>(
          future: storeService.getStoreDetails(ownerId: getStringAsync(USER_ID), isDeleted: false),
          builder: (context, snap) {
            if (snap.hasData) {
              if (snap.data == null) {
                return Text("No data found", style: primaryTextStyle());
              }
              storeModel = snap.data;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cachedImage(storeModel!.photoUrl.validate(), fit: BoxFit.cover, width: 150, height: 150).cornerRadiusWithClipRRect(100).paddingAll(16),
                    Divider(),
                    detailItemWidget(title: "Name", data: storeModel!.storeName),
                    detailItemWidget(title: "Email", data: storeModel!.storeEmail),
                    detailItemWidget(title: "Contact", data: storeModel!.storeContact),
                    detailItemWidget(title: "Description", data: storeModel!.storeDesc),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          child: Text("Categories", style: secondaryTextStyle(), textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis),
                        ),
                        32.width,
                        Row(
                          children: storeModel!.catList!.map((e) => Text(e.validate(), style: primaryTextStyle()).paddingRight(8)).toList(),
                        ),
                      ],
                    ).paddingAll(16),
                  ],
                ),
              );
            }
            return snapWidgetHelper(snap);
          },
        ),
      ),
    );
  }

  Widget detailItemWidget({String? title, String? data, Widget? widget}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          child: Text(title.validate(), style: secondaryTextStyle(), textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis),
        ),
        32.width,
        Text(data.validate(), style: primaryTextStyle(), textAlign: TextAlign.justify).expand(),
      ],
    ).paddingAll(16);
  }
}
