import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:deliverytap_delivery/components/AppWidgets.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/model/OrderModel.dart';
import 'package:deliverytap_delivery/model/UserModel.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/utils/Common.dart';
import 'package:deliverytap_delivery/utils/Constants.dart';
import 'package:deliverytap_delivery/utils/ModelKey.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as GC;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class TrackingScreen extends StatefulWidget {
  OrderModel? orderModel;

  String? orderId;

  TrackingScreen({this.orderModel, this.orderId});

  @override
  TrackingScreenState createState() => TrackingScreenState();
}

class TrackingScreenState extends State<TrackingScreen> {
  UserModel? userData;
  String? addressStore;

  // ignore: non_constant_identifier_names
  double CAMERA_ZOOM = 13;

  // ignore: non_constant_identifier_names
  double CAMERA_TILT = 0;

  // ignore: non_constant_identifier_names
  double CAMERA_BEARING = 30;

  // ignore: non_constant_identifier_names
  LatLng SOURCE_LOCATION = LatLng(0.0, 0.0);

  // ignore: non_constant_identifier_names
  LatLng DEST_LOCATION = LatLng(0.0, 0.0);

  // ignore: non_constant_identifier_names
  LatLng STORE_LOCATION = LatLng(0.0, 0.0);
  late CameraPosition initialLocation;

  String? userPlayerId = '';

  bool isReached = false;

  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();


  bool isError = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await loadBasicDetails();

    if (isError) {
      init();
      return toast(errorMessage);
    }

    DEST_LOCATION = LatLng(widget.orderModel!.userLocation!.latitude, widget.orderModel!.userLocation!.longitude);

    orderServices.getOrderById(widget.orderModel!.id).listen((order) {
      widget.orderModel = order;

      setState(() {});
    }).onError((error) {
      toast(error.toString());
    });

    if (appStore.isDarkMode) {
      setStatusBarColor(scaffoldColorDark);
    } else {
      setStatusBarColor(Colors.white);
    }

    setState(() {});
  }

  Future<void> loadBasicDetails() async {
    isError = false;

    if (widget.orderModel != null) {
      widget.orderId = widget.orderModel!.id;
    }
    if (widget.orderId != null) {
      await orderServices.getOrderByIdFuture(widget.orderId).then((value) {
        widget.orderModel = value;

        isReached = widget.orderModel!.orderStatus == ORDER_STATUS_DELIVERING || widget.orderModel!.orderStatus == ORDER_STATUS_COMPLETE;
      }).catchError((e) {
        isError = true;
      });
      await userService.getUserById(userId: widget.orderModel!.userId).then((user) {
        userData = user;

        userPlayerId = userData!.oneSignalPlayerId;
      }).catchError((e) {
        isError = true;
      });
      await storeService.getStoreById(storeId: widget.orderModel!.storeId).then((value) {
        addressStore = value.storeAddress;
      }).catchError((e) {
        isError = true;
      });
    }
  }

  Future<void> completeDelivery() async {
    /// Update document
    orderServices.updateDocument(widget.orderModel!.id, {
      OrderKey.orderStatus: ORDER_STATUS_COMPLETE,
      OrderKey.paymentStatus: ORDER_PAYMENT_RECEIVED,
      CommonKey.updatedAt: DateTime.now(),
    }).then((value) {
      finish(context);
    }).catchError((error) {
      toast(error.toString());
    });
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    setStatusBarColor(
      appStore.isDarkMode ? scaffoldColorDark : white,
      statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
      delayInMilliSeconds: 100,
    );
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    initialLocation = CameraPosition(
      zoom: CAMERA_ZOOM,
      bearing: CAMERA_BEARING,
      tilt: CAMERA_TILT,
      target: SOURCE_LOCATION,
    );

    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget('#${widget.orderModel?.orderId?.validate()}'),
        body: widget.orderModel != null
            ? Stack(
          alignment: Alignment.center,
          children: [
            AppButton(
              text: "View Location",
              textStyle: primaryTextStyle(color: white),
              color: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              onTap: () async {
                if(widget.orderModel!.orderStatus == ORDER_STATUS_READY){
                  MapsLauncher.launchQuery(addressStore!);
                }
                if(widget.orderModel!.orderStatus == ORDER_STATUS_DELIVERING){
                  MapsLauncher.launchQuery(widget.orderModel!.userAddress!);
                }
              },
            ),
            if (userData != null)
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)), color: appStore.isDarkMode ? backColor : white),
                  width: context.width(),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          commonCachedNetworkImage(userData!.photoUrl.validate(), fit: BoxFit.cover, height: 50, width: 50)
                              .cornerRadiusWithClipRRect(8)
                              .visible(userData!.photoUrl.validate().isNotEmpty),
                          Icon(Icons.person, size: 40).visible(userData!.photoUrl.validate().isEmpty),
                          8.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userData!.name.validate(), style: boldTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                              4.height,
                              Text(userData!.number.validate(), style: primaryTextStyle(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ).expand(),
                          Container(
                            decoration: BoxDecoration(borderRadius: radius(), color: white, boxShadow: defaultBoxShadow()),
                            height: 35,
                            width: 35,
                            child: Icon(Icons.call, color: blueButtonColor),
                          ).onTap(() {
                            launch("tel://${userData!.number}");
                          })
                        ],
                      ).paddingAll(8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          createRichText(
                            list: [
                              TextSpan(text: widget.orderModel!.userAddress.validate(), style: primaryTextStyle()),
                            ],
                            maxLines: 5,
                          ),
                          8.height,
                          orderStatusWidget(widget.orderModel!.orderStatus),
                        ],
                      ).paddingAll(8),
                      Row(
                        children: [
                          AppButton(
                            text: "Start",
                            textStyle: primaryTextStyle(color: white),
                            color: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            onTap: () async {
                              showConfirmDialog(context, "Did you picked up the parcel?", positiveText: "Yes", negativeText: "No")
                                  .then((value) async {
                                if (value ?? false) {
                                  DEST_LOCATION = LatLng(widget.orderModel!.userLocation!.latitude, widget.orderModel!.userLocation!.longitude);
                                  isReached = true;

                                  await orderServices.updateDocument(widget.orderModel!.id, {
                                    OrderKey.orderStatus: ORDER_STATUS_DELIVERING,
                                    CommonKey.updatedAt: DateTime.now(),
                                  }).then((value) {
                                    //
                                  }).catchError((error) {
                                    toast(error.toString());
                                  });
                                  setState(() {});
                                }
                              });
                            },
                          ).visible(widget.orderModel!.orderStatus == ORDER_STATUS_READY),
                          8.width,
                          if (widget.orderModel != null)
                            AppButton(
                              text: "Complete",
                              textStyle: primaryTextStyle(color: white),
                              color: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              onTap: () {
                                showConfirmDialog(context, "Did you reached the destination and got payment?",
                                    positiveText: "Yes", negativeText: "No")
                                    .then((value) {
                                  if (value ?? false) {
                                    completeDelivery();
                                  }
                                });
                              },
                            ).visible(
                              widget.orderModel!.orderStatus == ORDER_STATUS_DELIVERING,
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            Observer(builder: (_) => Align(alignment: Alignment.center, child: Loader(color: Colors.red).visible(appStore.isLoading))),
          ],
        )
            : Loader(),
      ),
    );
  }
}
