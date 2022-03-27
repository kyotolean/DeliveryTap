import 'package:deliverytap_admin/models/SideDrawerModel.dart';
import 'package:deliverytap_admin/screens/Admin/CategoryScreen.dart';
import 'package:deliverytap_admin/screens/Admin/StoreFragment.dart';


import 'package:nb_utils/nb_utils.dart';

import 'Constants.dart';

List<SideDrawerModel> getDrawerList() {
  List<SideDrawerModel> list = [];

  list.add(SideDrawerModel(img: 'images/ic_home.png', title: 'Dashboard', widget: CategoryScreen()));

  list.add(SideDrawerModel(img: 'images/ic_order.png', title: 'Order'));
  if (!getBoolAsync(IS_ADMIN)) {
    list.add(SideDrawerModel(img: 'images/ic_menu.png', title: 'Menu'));
  }
  if (getBoolAsync(IS_ADMIN)) {
    list.add(SideDrawerModel(img: 'images/ic_menu.png', title: 'Categories', widget: CategoryScreen()));
    list.add(SideDrawerModel(img: 'images/home.png', title: 'Store', widget: StoreFragment()));
    list.add(SideDrawerModel(img: 'images/ic_user.png', title: 'Users'));
  }
  list.add(SideDrawerModel(img: 'images/ic_settings.png', title: 'Setting'));

  return list;
}