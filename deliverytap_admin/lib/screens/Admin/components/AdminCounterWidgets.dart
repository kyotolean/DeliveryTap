import 'package:flutter/material.dart';
import 'package:deliverytap_admin/components/AppWidgets.dart';
import 'package:deliverytap_admin/utils/Common.dart';

import '../../../main.dart';

class CountWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        double width = context.isMobile()
            ? constraint.maxWidth / 1
            : context.isTab()
            ? constraint.maxWidth / 2
            : constraint.maxWidth / 4;
        return Wrap(
          children: [
            Container(
              width: width,
              child: streamBuilderWidget(stream: userService.getAllUsers(role: ''), title: "Total User"),
            ),
            Container(
              width: width,
              child: streamBuilderWidget(stream: orderService.getOrders(), title: "Total Order"),
            ),
            Container(
              width: width,
              child: streamBuilderWidget(stream: storeService.getAllStores(), title: "Total Stores"),
            ),
            Container(
              width: width,
              child: streamBuilderWidget(stream: categoryService.getCategory(), title: "Total Category"),
            ),
            Container(
              width: width,
              child: streamBuilderWidget(stream: itemsService.getItemsData(), title: "Total Items"),
            ),
          ],
        );
      },
    );
  }
}
