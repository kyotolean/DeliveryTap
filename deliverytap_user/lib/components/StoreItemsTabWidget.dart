import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_user/models/CartModel.dart';
import 'package:deliverytap_user/models/StoreModel.dart';
import 'package:deliverytap_user/screens/CartScreen.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/Widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../main.dart';
import 'ItemWidget.dart';

// ignore: must_be_immutable
class StoreItemsTabWidget extends StatefulWidget {
  static String tag = '/StoreItemsTabWidget';
  StoreModel? storeData;

  StoreItemsTabWidget({this.storeData});

  @override
  StoreItemsTabWidgetState createState() => StoreItemsTabWidgetState();
}

class StoreItemsTabWidgetState extends State<StoreItemsTabWidget> {
  UniqueKey uniqueKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: uniqueKey,
      children: [
        PaginateFirestore(
          itemBuilderType: PaginateBuilderType.listView,
          itemBuilder: (context, documentSnapshot,index) {
            CartModel items = CartModel.fromJson(documentSnapshot[index].data() as Map<String, dynamic>);

            return ItemWidget(
              items: items,
              onUpdate: () {
                uniqueKey = UniqueKey();
                setState(() {});
              },
            );
          },
          padding: EdgeInsets.all(8),
          query: itemDBService.storesItemsQuery(widget.storeData!.id.validate()),
          isLive: true,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemsPerPage: DocLimit,
          bottomLoader: Loader(),
          initialLoader: Loader(),
          onEmpty: noDataWidget(errorMessage: "No Data Found"),
          onError: (e) => Text(e.toString(), style: primaryTextStyle()).center(),
          separator: Divider(),
        ),
        Observer(
          builder: (_) => viewCartWidget(
              context: context,
              totalItemLength: '${appStore.mCartList.length}',
              onTap: () {
                CartScreen(isRemove: true, deliveryCharge: widget.storeData!.deliveryCharge).launch(context);
              }).visible(appStore.mCartList.isNotEmpty),
        )
      ],
    );
  }
}
