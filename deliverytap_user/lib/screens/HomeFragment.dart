import 'package:flutter/material.dart';
import 'package:deliverytap_user/components/CategoryItemComponent.dart';
import 'package:deliverytap_user/components/StoreItemComponent.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/models/CategoryModel.dart';
import 'package:deliverytap_user/models/StoreModel.dart';
import 'package:deliverytap_user/screens/LoginScreen.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:deliverytap_user/utils/ModalKeys.dart';
import 'package:deliverytap_user/utils/Widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'OrderDetailsScreen.dart';

class HomeFragment extends StatefulWidget {
  static String tag = '/HomeFragment';

  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> with AfterLayoutMixin<HomeFragment> {
  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();

  TextEditingController searchCont = TextEditingController();

  String searchText = '';

  LatLng? userLatLng;

  int retry = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    checkPermission();
    setStatusBarColor(
      context.scaffoldBackgroundColor,
      statusBarIconBrightness: Brightness.dark,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      if (!appStore.isLoggedIn) {
        LoginScreen().launch(context, isNewTask: true);
      }else {
        if (result.notification.additionalData!.containsKey('orderId')) {
          String? orderId = result.notification.additionalData!['orderId'];

          myOrderDBService.getOrderById(orderId).then((value) {
            OrderDetailsScreen(listOfOrder: value.listOfOrder, orderData: value).launch(context);
          }).catchError((e) {
            toast(e.toString());
          });
        }
      }
    });
  }

  Future<void> checkPermission() async {
    LocationPermission locationPermission = await Geolocator.requestPermission();

    if (locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always) {
      if ((await Geolocator.isLocationServiceEnabled())) {
        getUserLocation();
      } else {
        Geolocator.openLocationSettings().then((value) {
          if (value) getUserLocation();
        });
      }
    } else {
      Geolocator.openAppSettings();
    }
  }

  Future<void> getUserLocation() async {
    if (retry >= 3) return;
    retry++;

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    if (place.locality != null) {
      userCityNameGlobal = place.locality;
    } else {
      userCityNameGlobal = place.subLocality;
    }
    String address = "${place.name != null ? place.name : place.subThoroughfare}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";
    userAddressGlobal = address;

    if (userCityNameGlobal.validate().isNotEmpty) {
      await appStore.setCityName(userCityNameGlobal);

      if (appStore.isLoggedIn) {
        Map<String, dynamic> data = {
          UserKeys.city: userCityNameGlobal,
          CommonKeys.updatedAt: DateTime.now(),
        };

        await userDBService.updateDocument(data, appStore.userId).then((res) async {
          //
        }).catchError((error) {
          appStore.setLoading(false);
          toast(error.toString());
        });
      }
    } else {
      getUserLocation();
    }

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: colorPrimary,
      backgroundColor: context.cardColor,
      onRefresh: () async {

        setState(() {});
        await 2.seconds.delay;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  appStore.userProfileImage.validate().isEmpty
                      ? Icon(Icons.person_outline, size: 30)
                      : cachedImage(
                    appStore.userProfileImage.validate(),
                    usePlaceholderIfUrlEmpty: true,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(30),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Hello,', style: boldTextStyle(size: 20)),
                          4.width,
                          Text(appStore.userFullName.validate(), style: boldTextStyle(size: 18)),
                        ],
                      ),
                      Text(userAddressGlobal.validate(), style: secondaryTextStyle(size: 12)),
                    ],
                  ).visible(appStore.isLoggedIn).expand(),
                ],
              ).paddingAll(16).visible(appStore.isLoggedIn),
              Row(
                children: <Widget>[
                  Container(
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: viewLineColor),
                      backgroundColor: Colors.white,
                    ),
                  ).expand(),
                ],
              ).paddingOnly(left: 16, right: 16, top: 8, bottom: 8),
              20.height,
              Text("Categories", style: boldTextStyle(size: 24)).paddingLeft(16).visible(searchText.isEmpty),
              Container(
                height: 200,
                child: StreamBuilder<List<CategoryModel>>(
                  stream: categoryDBService.categories(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return Text(snapshot.error.toString()).center();

                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return noDataWidget(errorMessage: errorMessage).center();
                      } else {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(top: 16, bottom: 16, right: 16),
                          itemBuilder: (context, index) {
                            return CategoryItemComponent(category: snapshot.data![index]);
                          },
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                        );
                      }
                    }
                    return Loader().center();
                  },
                ),
              ).visible(searchText.isEmpty),
              Text("Stores", style: boldTextStyle(size: 24)).paddingLeft(16),
              searchText.isNotEmpty && getStringAsync(USER_CITY_NAME).isNotEmpty
                  ? StreamBuilder<List<StoreModel>>(
                  stream: storeDBService.stores(searchText: searchText),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return Text(snapshot.error.toString()).center();
                    if (snapshot.hasData) {
                      if (snapshot.data!.length == 0) {
                        return Container(
                          child: noDataWidget(errorMessage: "No Store Found"),
                          margin: EdgeInsets.only(top: 100),
                        ).center();
                      } else {
                        return ListView.builder(
                          itemBuilder: (context, index) => StoreItemComponent(
                            store: snapshot.data![index],
                          ),
                          padding: EdgeInsets.all(8),
                          itemCount: snapshot.data!.length,
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                        );
                      }
                    }
                    return Loader().center();
                  })
                  : getStringAsync(USER_CITY_NAME).isNotEmpty
                  ? PaginateFirestore(
                  itemBuilderType: PaginateBuilderType.listView,
                  listeners: [refreshChangeListener],
                  itemBuilder: (context, documentSnapshot, index) {
                    return StoreItemComponent(store: StoreModel.fromJson(documentSnapshot[index].data() as Map<String, dynamic>));
                  },
                  query: storeDBService.storesQuery(searchText: searchText),
                  isLive: true,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemsPerPage: DocLimit,
                  padding: EdgeInsets.all(8),
                  bottomLoader: Loader(),
                  initialLoader: Loader(),
                  onEmpty: noDataWidget(errorMessage: "No Store Found"),
                  onError: (e) => Text(e.toString(), style: primaryTextStyle()).center(),
                )
                  : Container(
                child: noDataWidget(errorMessage: "No Store Found"),
                margin: EdgeInsets.only(top: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
