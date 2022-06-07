import 'package:flutter/material.dart';

class SideDrawerModel {
  String? title;
  String? img;
  Widget? widget;
  List<SideDrawerModel>? items;
  bool isExpand;

  SideDrawerModel({this.title, this.img, this.widget, this.items, this.isExpand = false});
}
