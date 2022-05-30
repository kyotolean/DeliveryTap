import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_user/components/AddressListComponent.dart';
import 'package:deliverytap_user/models/UserModel.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/MapAddressItemComponent.dart';
import '../main.dart';
import 'MapAddressScreen.dart';

// ignore: must_be_immutable
class MyAddressScreen extends StatefulWidget {
  static String tag = '/MyAddressScreen';
  bool? isOrder = false;

  MyAddressScreen({this.isOrder});

  @override
  MyAddressScreenState createState() => MyAddressScreenState();
}

class MyAddressScreenState extends State<MyAddressScreen> {
  double? userLatitude;
  double? userLongitude;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    getCurrentUserLocation();
  }

  Future<void> getCurrentUserLocation() async {
    final geoPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userLatitude = geoPosition.latitude;
    userLongitude = geoPosition.longitude;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget("My Address", color: context.cardColor),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SettingItemWidget(
                padding: EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 8),
                leading: Icon(Icons.add, color: colorPrimary),
                title: "Add address",
                titleTextStyle: primaryTextStyle(color: colorPrimary),
                onTap: () async {
                  if (userLatitude != null) {
                    MapAddressScreen(userLatitude: userLatitude, userLongitude: userLongitude).launch(context);
                  } else {
                    getCurrentUserLocation();
                  }
                },
              ),
              Stack(
                children: [
                  StreamBuilder<UserModel>(
                    stream: userDBService.userById(appStore.userId),
                    builder: (_, snap) {
                      if (snap.hasData) {
                        return AddressListComponent(userData: snap.data, isOrder: widget.isOrder);
                      } else {
                        return snapWidgetHelper(snap);
                      }
                    },
                  ),
                  Observer(builder: (_) => Loader().center().visible(appStore.isLoading)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
