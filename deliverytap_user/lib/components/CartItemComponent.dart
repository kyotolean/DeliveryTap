import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:deliverytap_user/models/CartModel.dart';
import 'package:deliverytap_user/screens/LoginScreen.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

// ignore: must_be_immutable
class CartItemComponent extends StatefulWidget {
  static String tag = '/CartItemComponent';
  final Function onUpdate;
  bool? isCartScreen;
  CartModel? cartData;

  CartItemComponent({this.cartData, required this.onUpdate, this.isCartScreen});

  @override
  CartItemComponentState createState() => CartItemComponentState();
}

class CartItemComponentState extends State<CartItemComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future addToCart(String id, int qty) async {
    widget.cartData!.qty = widget.cartData!.qty! + 1;

    appStore.updateCartData(id, widget.cartData);

    Map<String, dynamic> req = {
      CommonKeys.qty: FieldValue.increment(1),
      CommonKeys.updatedAt: DateTime.now(),
    };

    myCartDBService.updateDocument(req, id).then((value) {
      qty++;
    }).catchError((e) {
      log(e);
    });
  }

  Future removeToCart(String id, int qty) async {
    widget.cartData!.qty = widget.cartData!.qty! - 1;

    appStore.updateCartData(id, widget.cartData);

    Map<String, dynamic> req = {
      CommonKeys.qty: qty - 1,
      CommonKeys.updatedAt: DateTime.now(),
    };
    if (widget.cartData!.qty == 0) {
      removeToCartItem(widget.cartData!.id);
    } else {
      await myCartDBService.updateDocument(req, id).then((value) {
        if(widget.cartData!.qty == 0){
          removeToCartItem(id);
        }else{
          qty--;
        }
      }).catchError((e) {
        log(e);
      });
    }
  }

  Future<void> removeToCartItem(String? id) async {
    appStore.updateCartData(id!, widget.cartData);
    await myCartDBService.removeDocument(id).then((value) {
      appStore.mCartList.forEach((element) {
        if (element!.id == widget.cartData!.id) {
          widget.onUpdate.call();

          appStore.removeFromCart(element);
          appStore.setQtyExist(false);
        }
      });
      setState(() {});
      toast('Removed');
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: context.scaffoldBackgroundColor,
            boxShadow: defaultBoxShadow(spreadRadius: 0.0, blurRadius: 0.0),
            border: Border.all(color: context.dividerColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: cachedImage(
            widget.cartData!.image.validate(),
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRect(16),
        ),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.cartData!.itemName.validate(),
              style: primaryTextStyle(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            widget.cartData!.categoryName != null ? Text('In ${widget.cartData!.categoryName}', style: secondaryTextStyle(size: 12)) : SizedBox(),
            4.height,
            Text(getAmount(widget.cartData!.itemPrice! * widget.cartData!.qty!), style: boldTextStyle()),
          ],
        ).expand(),
        4.width,
        Container(
          padding: EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: viewLineColor)),
          child: Row(
            children: [
              Icon(Icons.remove, size: 20, color: colorPrimary).paddingSymmetric(horizontal: 8).visible(appStore.mCartList.isNotEmpty).onTap(() {
                if (appStore.isLoggedIn) {
                  removeToCart(widget.cartData!.id.validate(), widget.cartData!.qty.validate());
                } else
                  LoginScreen().launch(context);
              }),
              4.width,
              Text("${widget.cartData!.qty.validate()}", style: primaryTextStyle()),
              4.width,
              Icon(Icons.add, size: 20, color: colorPrimary).paddingSymmetric(horizontal: 8).visible(appStore.mCartList.isNotEmpty).onTap(() {
                if (appStore.isLoggedIn) {
                  addToCart(widget.cartData!.id.validate(), widget.cartData!.qty.validate());
                } else
                  LoginScreen().launch(context);
              }),
            ],
          ),
        ),
      ],
    ).paddingOnly(bottom: 16, left: 16);
  }
}
