import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_user/models/CartModel.dart';
import 'package:deliverytap_user/screens/LoginScreen.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ItemWidget extends StatefulWidget {
  final CartModel? items;
  final Function? onUpdate;

  ItemWidget({this.items, this.onUpdate});

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    var contain = appStore.mCartList.where((element) => element!.id.validate() == widget.items!.id.validate());
    if (contain.isEmpty) {
      appStore.setQtyExist(false);
    } else {
      appStore.setQtyExist(true);
    }
    setState(() {});
  }

  Future<void> addToCart() async {
    if (getStringAsync(STORE_NAME) != widget.items!.storeName) {
      await Future.forEach(appStore.mCartList, (dynamic element) async {
        await myCartDBService.removeDocument(element.id);
      });
      appStore.clearCart();
    }
    await myCartDBService.addDocumentWithCustomId(widget.items!.id, widget.items!.toJson()).then((value) {
      appStore.addToCart(widget.items);

      setValue(STORE_ID, widget.items!.storeId);
      setValue(STORE_NAME, widget.items!.storeName);
      appStore.setQtyExist(true);

      widget.onUpdate?.call();

      toast("Added");
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });
  }

  Future<void> removeToCart() async {
    await myCartDBService.removeDocument(widget.items!.id).then((value) {
      appStore.mCartList.forEach((element) {
        if (element!.id == widget.items!.id) {
          appStore.removeFromCart(element);
        }
      });

      appStore.setQtyExist(false);
      widget.onUpdate?.call();
      toast("Removed");
      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: context.scaffoldBackgroundColor,
            boxShadow: defaultBoxShadow(spreadRadius: 0.0, blurRadius: 0.0),
            border: Border.all(color: context.dividerColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: cachedImage(
            widget.items!.image.validate(),
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRect(16),
        ),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.items!.itemName.validate(),
                  style: primaryTextStyle(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ).expand(),
                4.width,
                Observer(
                  builder: (_) {
                    return !appStore.mCartList.any((element) => widget.items!.id == element!.id)
                        ? Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: viewLineColor), color: colorPrimary),
                      child: Text("Add to cart", style: primaryTextStyle(size: 12, color: Colors.white)),
                    ).onTap(() {
                      if (appStore.isLoggedIn) {
                        addToCart();
                      } else
                        LoginScreen().launch(context);
                    })
                        : Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: viewLineColor), color: Colors.white),
                      child: Text("Remove cart", style: primaryTextStyle(size: 12, color: Colors.black)).onTap(() {
                        removeToCart();
                      }),
                    );
                  },
                )
              ],
            ),
            widget.items!.categoryName != null ? Text('In ${widget.items!.categoryName}', style: secondaryTextStyle(size: 12)) : SizedBox(),
            4.height,
            Text(getAmount(widget.items!.itemPrice.validate()), style: boldTextStyle()),
            4.height,
          ],
        ).expand(),
      ],
    ).paddingAll(8);
  }
}
