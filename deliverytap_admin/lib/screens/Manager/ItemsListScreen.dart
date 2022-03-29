import 'package:flutter/material.dart';
import 'package:deliverytap_admin/components/AppWidgets.dart';
import 'package:deliverytap_admin/models/ItemsModel.dart';
import 'package:deliverytap_admin/models/StoreModel.dart';
import 'package:deliverytap_admin/screens/Manager/AddItemDetails.dart';
import 'package:deliverytap_admin/utils/Colors.dart';
import 'package:deliverytap_admin/utils/Common.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

// ignore: must_be_immutable
class ItemsListScreen extends StatefulWidget {
  static String tag = '/ItemsListScreen';
  StoreModel? storeModel;

  ItemsListScreen({this.storeModel});

  @override
  ItemsListScreenState createState() => ItemsListScreenState();
}

class ItemsListScreenState extends State<ItemsListScreen> {
  ScrollController scrollController = ScrollController();

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
      appBar: appBarWidget("Items List", showBack: getBoolAsync(IS_ADMIN) ? true : false, elevation: 0),
      body: StreamBuilder<List<ItemsModel>>(
        stream: itemsService.getItemsData(storeId: widget.storeModel == null ? getStringAsync(STORE_ID) : widget.storeModel!.id),
        builder: (_, snap) {
          if (snap.hasData) {
            if (snap.data!.isEmpty) {
              return Text("No data found", style: primaryTextStyle()).center();
            }
            List<ItemsModel> items = snap.data!;
            return Container(
              width: context.width(),
              child: SingleChildScrollView(
                controller: scrollController,
                child: SingleChildScrollView(
                  scrollDirection: context.isDesktop() ? Axis.vertical : Axis.horizontal,
                  child: DataTable(
                    dataRowHeight: 70,
                    columns: [
                      DataColumn(label: Text(ItemsTableKey.image, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(ItemsTableKey.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(ItemsTableKey.description, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(ItemsTableKey.category, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(ItemsTableKey.price, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(ItemsTableKey.action, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    ],
                    rows: items.map(
                          (e) {
                        return DataRow(
                          cells: [
                            DataCell(cachedImage(e.image.validate(), height: 50, width: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(60)),
                            DataCell(Container(width: 200, child: Text(e.itemName.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis))),
                            DataCell(Container(width: 200, child: Text(e.description.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis))),
                            DataCell(Text(e.categoryName!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            DataCell(Text('${e.itemPrice.validate().toAmount()}', style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit_outlined),
                                    color: Colors.green,
                                    onPressed: () {
                                      AddItemDetails(itemsModel: e).launch(context);
                                    },
                                  ),
                                  8.width,
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.delete_forever_outlined),
                                    color: Colors.red,
                                    onPressed: () async {
                                      bool? isDeleted = await showInDialog(
                                        context,
                                        child: Text("Sure you want delete this item?", style: primaryTextStyle()),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                finish(context, false);
                                              },
                                              child: Text("Cancel", style: primaryTextStyle())),
                                          TextButton(
                                              onPressed: () {
                                                finish(context, true);
                                              },
                                              child: Text("Delete", style: primaryTextStyle())),
                                        ],
                                      );
                                      if (getBoolAsync(IS_TESTER)) {
                                        return toast("Tester role not allowed to perform this action");
                                      } else {
                                        if (isDeleted!) {
                                          itemsService.removeDocument(e.id).then((value) {
                                            toast("Item delete successfully");
                                          }).catchError((error) {
                                            toast(error.toString());
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            );
          }
          return snapWidgetHelper(snap);
        },
      ),
      floatingActionButton: Container(
        height: 50,
        width: 185,
        color: colorPrimary,
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: white),
            4.width,
            Text("Add Item", style: boldTextStyle(color: white)),
          ],
        ),
      ).cornerRadiusWithClipRRect(defaultRadius).onTap(() {
        if (getBoolAsync(IS_TESTER)) {
          return toast("Tester role not allowed to perform this action");
        } else {
          AddItemDetails(storeModel: widget.storeModel).launch(context);
        }
      }),
    );
  }
}
