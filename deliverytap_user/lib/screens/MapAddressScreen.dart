import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:deliverytap_user/components/MapAddressItemComponent.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

// ignore: must_be_immutable
class MapAddressScreen extends StatefulWidget {
  double? userLatitude;
  double? userLongitude;
  String? address;
  bool? isUpdate;

  MapAddressScreen({this.userLatitude, this.userLongitude, this.address, this.isUpdate});

  @override
  _LocationChooserState createState() => _LocationChooserState();
}

class _LocationChooserState extends State<MapAddressScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController otherDetailsController = TextEditingController();

  FocusNode addressFocus = FocusNode();
  FocusNode otherDetailsFocus = FocusNode();

  Completer<GoogleMapController> _controller = Completer();
  TextEditingController addressController = TextEditingController();

  MapType currentMapType = MapType.normal;

  LatLng? userLatLong;
  LatLng? lastMapPosition;
  final Set<Marker> markers = {};

  String? title = "";
  String detail = "";

  double? deliveryUserLat;
  double? deliveryUserLong;

  @override
  void initState() {
    super.initState();
    init();
    setStatusBarColor(
      Colors.white,
      statusBarIconBrightness: Brightness.dark,
    );
  }

  init() async {
    userLatLong = LatLng(widget.userLatitude.validate(), widget.userLongitude.validate());

    lastMapPosition = userLatLong;

    markers.add(
      Marker(
        markerId: MarkerId(userLatLong.toString()),
        position: userLatLong!,
        infoWindow: InfoWindow(title: title, snippet: detail),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ),
    );
    getUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onCameraMove(CameraPosition position) {
    lastMapPosition = position.target;
  }

  _handleTap(LatLng point) {
    markers.clear();
    getLocation(point);
    setState(() {
      markers.add(Marker(
        markerId: MarkerId("Order Detail"),
        position: point,
        infoWindow: InfoWindow(title: title, snippet: detail),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
    });
  }

  getLocation(LatLng point) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(point.latitude, point.longitude);
    Placemark place = placemarks[0];

    if (place.locality != null) {
      userCityNameGlobal = place.locality;
    }
    String address = "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";
    setState(() {
      title = place.name;
      detail = address;
      addressController.text = detail;
      deliveryUserLat = point.latitude;
      deliveryUserLong = point.longitude;
    });
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    if (place.locality != null) {
      userCityNameGlobal = place.locality;
    }
    String address = "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16),
      ),
    );

    setState(() {
      title = place.name;
      detail = address;
      addressController.text = detail;
      deliveryUserLat = position.latitude;
      deliveryUserLong = position.longitude;
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<LatLng>('userLatLong', userLatLong));
  }

  @override
  void dispose() {
    setStatusBarColor(
      Colors.white,
      statusBarIconBrightness: Brightness.dark,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Stack(
              children: [
                GoogleMap(
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(target: userLatLong!, zoom: 11.0),
                  markers: markers,
                  mapType: currentMapType,
                  onCameraMove: _onCameraMove,
                  onTap: _handleTap,
                ),
                Icon(Icons.arrow_back_outlined).onTap(() {
                  finish(context);
                }).paddingOnly(top: 16, left: 8)
              ],
            ),
            MapAddressItemComponent(
              addressController: addressController,
              deliveryUserLat: deliveryUserLat,
              deliveryUserLong: deliveryUserLong,
            ),
          ],
        ),
      ),
    );
  }
}
