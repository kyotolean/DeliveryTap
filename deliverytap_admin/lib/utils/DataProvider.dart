import 'package:deliverytap_admin/models/SideDrawerModel.dart';
import 'package:deliverytap_admin/screens/Admin/CategoryScreen.dart';
import 'package:deliverytap_admin/screens/Admin/StoreFragment.dart';
import 'package:deliverytap_admin/screens/Admin/UserFragment.dart';
import 'package:deliverytap_admin/screens/HomeFragment.dart';
import 'package:deliverytap_admin/screens/Manager/CompletedOrderScreen.dart';
import 'package:deliverytap_admin/screens/Manager/DeliveringOrderScreen.dart';
import 'package:deliverytap_admin/screens/Manager/ItemsListScreen.dart';
import 'package:deliverytap_admin/screens/Manager/NewOrderScreen.dart';
import 'package:deliverytap_admin/screens/Manager/PackingOrderScreen.dart';
import 'package:deliverytap_admin/screens/Manager/StoreDetailScreen.dart';

import 'package:nb_utils/nb_utils.dart';

import 'Constants.dart';

List<SideDrawerModel> getDrawerList() {
  List<SideDrawerModel> list = [];

  list.add(SideDrawerModel(img: 'images/ic_home.png', title: 'Dashboard', widget: HomeFragment()));

  list.add(SideDrawerModel(img: 'images/ic_order.png', title: 'Order', widget: NewOrderScreen(), items: [
    SideDrawerModel(title: "New Orders", widget: NewOrderScreen()),
    SideDrawerModel(title: "Packing", widget: PackingOrderScreen()),
    SideDrawerModel(title: "Delivering", widget: DeliveringOrderScreen()),
    SideDrawerModel(title: "Completed", widget: CompletedOrderScreen()),
  ]));
  if (!getBoolAsync(IS_ADMIN)) {
    list.add(SideDrawerModel(img: 'images/ic_menu.png', title: 'Items', widget: StoreDetailScreen(), items: [
      SideDrawerModel(title: "Store Detail", widget: StoreDetailScreen()),
      SideDrawerModel(title: "Items Details", widget: ItemsListScreen()),
    ]));
  }
  if (getBoolAsync(IS_ADMIN)) {
    list.add(SideDrawerModel(img: 'images/ic_menu.png', title: 'Categories', widget: CategoryScreen()));
    list.add(SideDrawerModel(img: 'images/home.png', title: 'Store', widget: StoreFragment()));
    list.add(SideDrawerModel(img: 'images/ic_user.png', title: 'Users', widget: UserFragment(), items: [
      SideDrawerModel(title: "All User", widget: UserFragment(role: '')),
      SideDrawerModel(title: "Users", widget: UserFragment(role: USER)),
      SideDrawerModel(title: "Delivery Boy", widget: UserFragment(role: DELIVERY_BOY)),
      SideDrawerModel(title: 'Managers', widget: UserFragment(role: MANAGER)),
    ]));
  }

  return list;
}