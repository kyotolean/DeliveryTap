import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:deliverytap_admin/components/AppWidgets.dart';
import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/AddressModel.dart';
import 'package:deliverytap_admin/models/CategoryModel.dart';
import 'package:deliverytap_admin/models/StoreModel.dart';
import 'package:deliverytap_admin/models/UserModel.dart';
import 'package:deliverytap_admin/utils/Colors.dart';
import 'package:deliverytap_admin/utils/Common.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../DashboardScreen.dart';

class AddStoreDetailScreen extends StatefulWidget {
  static String tag = '/EditStoreDetailScreen';

  final StoreModel? storeModel;
  final bool isEdit;

  AddStoreDetailScreen({this.storeModel, this.isEdit = false});

  @override
  AddStoreDetailScreenState createState() => AddStoreDetailScreenState();
}

class AddStoreDetailScreenState extends State<AddStoreDetailScreen> {
  final kGoogleApiKey = googleMapKey;

  GlobalKey<FormState> _form = GlobalKey<FormState>();
  ScrollController controller = ScrollController();

  TextEditingController storePhotoUrlCont = TextEditingController();
  TextEditingController storeNameCont = TextEditingController();
  TextEditingController storeAddressCont = TextEditingController();
  TextEditingController storeNumberCont = TextEditingController();
  TextEditingController storeEmailCont = TextEditingController();
  TextEditingController storeDescCont = TextEditingController();
  TextEditingController deliveryCharge = TextEditingController();

  TextEditingController openTimeCont = TextEditingController();
  TextEditingController closeTimeCont = TextEditingController();

  TimeOfDay initialTime = TimeOfDay(hour: 00, minute: 00);

  FocusNode storePhotoUrlNode = FocusNode();
  FocusNode storeNameNode = FocusNode();
  FocusNode storeAddressNode = FocusNode();
  FocusNode storeNumberNode = FocusNode();
  FocusNode storeEmailNode = FocusNode();
  FocusNode storeDescNode = FocusNode();

  List<CategoryModel> category = [];

  List<String?> selectedCatName = [];

  List<UserModel> storeManagerList = [];
  UserModel? storeManager;

  bool isUpdate = false;

  String? storeCity = '';
  String? storeAddress = '';
  String? storeState = '';

  GeoPoint? storeGeoPoint;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.storeModel != null;

    categoryService.getCategory(showDeletedItem: false).listen((event) {
      category.addAll(event);
      if (isUpdate) {
        category.forEach((element) {
          if (selectedCatName.contains(element.categoryName)) {
            element.isCheck = true;
          } else {
            element.isCheck = false;
          }
        });
      }
      setState(() {});
    });

    if (getBoolAsync(IS_ADMIN)) {
      userService.getAllUsers(role: MANAGER).listen((event) {
        storeManagerList.clear();
        storeManagerList.addAll(event);
        storeManager = storeManagerList.first;
        setState(() {});
      });
    }

    if (isUpdate) {
      StoreModel storeModel = widget.storeModel!;

      storeNameCont.text = storeModel.storeName!;
      storeAddressCont.text = storeModel.storeAddress!;
      storeNumberCont.text = storeModel.storeContact!;
      storeEmailCont.text = storeModel.storeEmail!;
      storeDescCont.text = storeModel.storeDesc!;
      selectedCatName.addAll(storeModel.catList!);
      openTimeCont.text = storeModel.openTime!;
      closeTimeCont.text = storeModel.closeTime!;
      storePhotoUrlCont.text = storeModel.photoUrl!;
      storeCity = storeModel.storeCity;
      storeState = storeModel.storeState;
      deliveryCharge.text = storeModel.deliveryCharge == null ? '' : storeModel.deliveryCharge.toString();
    }
  }

  Future<TimeOfDay> timerPicker(BuildContext context) async {
    TimeOfDay? time = await showTimePicker(context: context, initialTime: initialTime);

    if (time != null) {
      return time;
    } else {
      throw "Something Went Wrong";
    }
  }

  Future<void> saveDetails() async {
    if (storeGeoPoint == null) {
      await getGeoPoint(storeAddressCont.text.trim()).then((value) {
        storeGeoPoint = value;
        return toast('Please select valid address for restaurant');
      }).catchError((e) {
        return toast(e.toString());
      });
    }

    if (_form.currentState!.validate()) {
      appStore.setLoading(true);
      _form.currentState!.save();

      StoreModel storeModel = StoreModel();

      storeModel.storeName = storeNameCont.text.trim().validate();
      storeModel.storeAddress = storeAddressCont.text.trim().validate();
      storeModel.storeCity = storeCity;
      storeModel.storeState = storeState;
      storeModel.storeContact = storeNumberCont.text.trim().validate();
      storeModel.storeEmail = storeEmailCont.text.trim().validate();
      storeModel.storeDesc = storeDescCont.text.trim().validate();
      storeModel.catList = selectedCatName;
      storeModel.openTime = openTimeCont.text.trim().validate();
      storeModel.closeTime = closeTimeCont.text.trim().validate();
      storeModel.caseSearch = setSearchParam(storeNameCont.text.trim().validate());
      storeModel.storeLatLng = storeGeoPoint;
      storeModel.deliveryCharge = deliveryCharge.text.toInt().validate();

      if (storePhotoUrlCont.text.isNotEmpty) {
        storeModel.photoUrl = storePhotoUrlCont.text.trim();
      }

      if (isUpdate) {
        storeModel.id = widget.storeModel!.id;
        storeModel.createdAt = widget.storeModel!.createdAt;
        storeModel.updatedAt = DateTime.now();
        storeModel.ownerId = widget.storeModel!.ownerId;
        storeModel.isDeleted = widget.storeModel!.isDeleted;

        //discount and coupon
        storeModel.isDealOfTheDay = widget.storeModel!.isDealOfTheDay;
        storeModel.couponCode = widget.storeModel!.couponCode;
        storeModel.couponDesc = widget.storeModel!.couponDesc;

        await storeService.updateDocument(storeModel.toJson(), widget.storeModel!.id).then((value) async {
          await setValue(STORE_ID, widget.storeModel!.id);
          finish(context);
        }).catchError((error) {
          toast(error.toString());
        });

        appStore.setLoading(false);
      } else {
        storeModel.createdAt = DateTime.now();
        storeModel.updatedAt = DateTime.now();
        storeModel.isDeleted = false;

        if (getBoolAsync(IS_ADMIN)) {
          storeModel.ownerId = storeManager!.uid;
        } else {
          storeModel.ownerId = getStringAsync(USER_ID);
        }

        //discount and coupon
        storeModel.isDealOfTheDay = false;
        storeModel.couponCode = '';
        storeModel.couponDesc = '';

        await storeService.addDocument(storeModel.toJson()).then((value) async {
          await setValue(STORE_ID, value.id);
          if (getBoolAsync(IS_ADMIN)) {
            finish(context);
          } else {
            DashboardScreen().launch(context, isNewTask: true);
          }
        }).catchError((error) {
          toast(error.toString());
        });

        await setValue(STORE_NAME, storeNameCont.text.trim());
        await setValue(STORE_CITY, storeCity);

        appStore.setLoading(false);
      }
    }
  }

  Future<GeoPoint?> getGeoPoint(String address) async {
    String url = 'https://maps.google.com/maps/api/geocode/json?key=$googleMapKey&address=${Uri.encodeComponent(address)}';
    Response res = await get(Uri.parse(url));

    if (res.statusCode.isSuccessful()) {
      AddressModel addressModel = AddressModel.fromJson(jsonDecode(res.body));

      if (addressModel.results!.isNotEmpty) {
        AddressResult addressResult = addressModel.results!.first;
        storeAddress = addressResult.formatted_address;

        addressResult.address_components!.forEach((element) {
          if (element.types!.contains('locality') || element.types!.contains('sublocality')) {
            storeCity = element.long_name;
          }
          if (element.types!.contains('administrative_area_level_1')) {
            storeState = element.long_name;
          }
        });

        storeGeoPoint = GeoPoint(addressResult.geometry!.location!.lat!, addressResult.geometry!.location!.lng!);
        storeAddressCont.text = storeAddress!;

        return storeGeoPoint;
      } else {
        throw 'Location Not found';
      }
    } else {
      throw "Something Went Wrong";
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Add Store", showBack: widget.storeModel != null || getBoolAsync(IS_ADMIN)),
      body: Container(
        width: context.width(),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Store Detail", style: boldTextStyle(size: 24)),
                    Divider(height: 32),
                    Row(
                      children: [
                        16.height,
                        Text('Store Managers: ', style: primaryTextStyle()),
                        8.width,
                        DropdownButton<UserModel>(
                            dropdownColor: context.cardColor,
                            value: storeManager,
                            hint: Text("Select Store Owner", style: primaryTextStyle()),
                            onChanged: (manager) {
                              storeManager = manager;
                              setState(() {});
                            },
                            items: storeManagerList.map<DropdownMenuItem<UserModel>>(
                                  (value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value.name.validate(), style: primaryTextStyle()),
                                );
                              },
                            ).toList()),
                      ],
                    ).visible(getBoolAsync(IS_ADMIN) && !widget.isEdit),
                    16.height,
                    Row(
                      children: [
                        cachedImage(storePhotoUrlCont.text.trim(), fit: BoxFit.cover, width: 150, height: 150, radius: 100),
                        24.width,
                        Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Store Name", style: primaryTextStyle()),
                                    8.height,
                                    AppTextField(
                                      controller: storeNameCont,
                                      focus: storeNameNode,
                                      nextFocus: storeAddressNode,
                                      textFieldType: TextFieldType.NAME,
                                      errorThisFieldRequired: "This field is required",
                                      decoration: inputDecoration(hintText: "Enter Store name"),
                                    ),
                                  ],
                                ).expand(),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Store Email", style: primaryTextStyle()),
                                    8.height,
                                    AppTextField(
                                      controller: storeEmailCont,
                                      focus: storeEmailNode,
                                      nextFocus: storeDescNode,
                                      textFieldType: TextFieldType.EMAIL,
                                      errorThisFieldRequired: "This field is required",
                                      errorInvalidEmail: emailError,
                                      decoration: inputDecoration(hintText: "Enter Email Address"),
                                    ),
                                  ],
                                ).expand(),
                              ],
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Store Image Url", style: primaryTextStyle()),
                                    8.height,
                                    AppTextField(
                                      controller: storePhotoUrlCont,
                                      focus: storePhotoUrlNode,
                                      nextFocus: storeNameNode,
                                      textFieldType: TextFieldType.NAME,
                                      errorThisFieldRequired: "This field is required",
                                      decoration: inputDecoration(hintText: "Enter Store image url"),
                                      onFieldSubmitted: (val) {
                                        storePhotoUrlCont.text = val;
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ).expand(),
                                16.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Store Contact", style: primaryTextStyle()),
                                    8.height,
                                    AppTextField(
                                      controller: storeNumberCont,
                                      focus: storeNumberNode,
                                      nextFocus: storeEmailNode,
                                      textFieldType: TextFieldType.PHONE,
                                      maxLength: 10,
                                      errorThisFieldRequired: "This field is required",
                                      decoration: inputDecoration(hintText: "Enter contact number"),
                                    ),
                                  ],
                                ).expand(),
                              ],
                            ),
                          ],
                        ).expand()
                      ],
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 230,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                          child: Scrollbar(
                            controller: controller,
                            isAlwaysShown: true,
                            showTrackOnHover: true,
                            child: SingleChildScrollView(
                              controller: controller,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Select Categories", style: primaryTextStyle(size: 22)),
                                  Divider(),
                                  Column(
                                    children: category.map((e) {
                                      return Row(
                                        children: [
                                          Checkbox(
                                            value: e.isCheck,
                                            onChanged: (val) {
                                              e.isCheck = val;
                                              if (e.isCheck!) {
                                                selectedCatName.add(e.categoryName);
                                              } else if (!e.isCheck!) {
                                                selectedCatName.remove(e.categoryName);
                                              }
                                              setState(() {});
                                            },
                                          ),
                                          Text(e.categoryName.validate(), style: primaryTextStyle())
                                        ],
                                      ).paddingOnly(top: 4, bottom: 4).onTap(() {
                                        e.isCheck = !e.isCheck!;
                                        if (e.isCheck!) {
                                          selectedCatName.add(e.categoryName);
                                        } else if (!e.isCheck!) {
                                          selectedCatName.remove(e.categoryName);
                                        }
                                        setState(() {});
                                      });
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).expand(),
                      ],
                    ),
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Delivery Charges", style: primaryTextStyle()),
                        8.height,
                        AppTextField(
                          controller: deliveryCharge,
                          textFieldType: TextFieldType.PHONE,
                          maxLength: 10,
                          decoration: inputDecoration(hintText: 'Delivery Charge'),
                          errorThisFieldRequired: "This field is required",
                        ),
                        Text("Store Address", style: primaryTextStyle()),
                        8.height,
                        AppTextField(
                          controller: storeAddressCont,
                          focus: storeAddressNode,
                          nextFocus: storeNumberNode,
                          minLines: 3,
                          textFieldType: TextFieldType.ADDRESS,
                          decoration: inputDecoration(hintText: "Enter store address"),
                          onTap: () {
                            //getAddress();
                          },
                          validator: (s) {
                            if (s!.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                        16.height,
                        AppButton(
                          text: "Get Address",
                          textStyle: primaryTextStyle(),
                          onTap: () async {
                            await getGeoPoint(storeAddressCont.text.trim()).then((value) {
                              storeGeoPoint = value;
                              setState(() {});
                            }).catchError((e) {
                              toast(e.toString());
                            });
                          },
                        )
                      ],
                    ),
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Enter description", style: primaryTextStyle()),
                        8.height,
                        AppTextField(
                          controller: storeDescCont,
                          focus: storeDescNode,
                          minLines: 3,
                          textFieldType: TextFieldType.ADDRESS,
                          errorThisFieldRequired: "This field is required",
                          decoration: inputDecoration(hintText: "Enter description"),
                          isValidationRequired: false,
                        ),
                      ],
                    ),
                    16.height,
                    Row(
                      children: [
                        Text('Store Timing : ', style: primaryTextStyle()),
                        8.width,
                        Container(
                          width: 150,
                          child: AppTextField(
                            controller: openTimeCont,
                            textFieldType: TextFieldType.OTHER,
                            errorInvalidEmail: emailError,
                            decoration: inputDecoration(hintText: "Open Time"),
                            validator: (s) {
                              if (s!.isEmpty) {
                                return "This field is required";
                              }
                              return null;
                            },
                            onTap: () {
                              timerPicker(context).then((value) {
                                openTimeCont.text = '${value.format(context)}';
                              }).catchError((error) {
                                toast(error.toString());
                              });
                            },
                          ),
                        ),
                        8.width,
                        Text("To", style: primaryTextStyle()),
                        8.width,
                        Container(
                          width: 150,
                          child: AppTextField(
                            controller: closeTimeCont,
                            textFieldType: TextFieldType.OTHER,
                            errorInvalidEmail: 'Invalid email address',
                            decoration: inputDecoration(hintText: "Close Time"),
                            validator: (s) {
                              if (s!.isEmpty) {
                                return "This field is required";
                                ;
                              }
                              return null;
                            },
                            onTap: () {
                              timerPicker(context).then((value) {
                                closeTimeCont.text = '${value.format(context)}';
                              }).catchError((error) {
                                toast(error.toString());
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    16.height,
                    AppButton(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                      onTap: () async {
                        if (getBoolAsync(IS_TESTER)) {
                          finish(context);
                          return toast("Tester role not allowed to perform this action");
                        } else {
                          saveDetails();
                        }
                      },
                      textStyle: primaryTextStyle(color: white),
                      color: colorPrimary,
                      child: Text("Save details", style: primaryTextStyle(size: 18, color: white)),
                    ),
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => Loader().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
