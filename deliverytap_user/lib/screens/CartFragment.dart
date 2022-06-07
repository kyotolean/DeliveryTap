import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_user/components/CartItemComponent.dart';
import 'package:deliverytap_user/models/CartModel.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'MyOrderScreen.dart';

class CartFragment extends StatefulWidget {
  static String tag = '/CartFragment';

  @override
  CartFragmentState createState() => CartFragmentState();
}

class CartFragmentState extends State<CartFragment> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget("Cart", showBack: false, elevation: 0, textSize: 28, color: Colors.white),
      body: Stack(
        children: [
          StreamBuilder<List<CartModel>>(
            stream: myCartDBService.cartList(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text(snapshot.error.toString()).center();
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return noDataWidget(errorMessage: "No Data Found").center();
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.only(top: 16, bottom: 16, right: 16),
                    itemBuilder: (context, index) => CartItemComponent(
                      cartData: snapshot.data![index],
                      onUpdate: () {
                        setState(() {});
                      },
                    ),
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                  );
                }
              }
              return Loader().center();
            },
          ),
          Observer(
            builder: (_) => viewCartWidget(
                context: context,
                totalItemLength: '${appStore.mCartList.length}',
                onTap: () async {
                  MyOrderScreen().launch(context);
                }).visible(appStore.mCartList.isNotEmpty && appStore.isLoggedIn),
          )],
      ),
    );
  }
}
