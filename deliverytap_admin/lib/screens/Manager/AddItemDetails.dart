import 'package:flutter/material.dart';
import 'package:deliverytap_admin/components/AppWidgets.dart';
import 'package:deliverytap_admin/models/CategoryModel.dart';
import 'package:deliverytap_admin/models/ItemsModel.dart';
import 'package:deliverytap_admin/models/StoreModel.dart';
import 'package:deliverytap_admin/utils/Common.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class AddItemDetails extends StatefulWidget {
  static String tag = '/AddItemDetails';
  final ItemsModel? itemsModel;

  final StoreModel? storeModel;

  AddItemDetails({this.itemsModel, this.storeModel});

  @override
  AddItemDetailsState createState() => AddItemDetailsState();
}

class AddItemDetailsState extends State<AddItemDetails> {
  ScrollController controller = ScrollController();
  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController itemImageUrlCont = TextEditingController();
  TextEditingController itemNameCont = TextEditingController();
  TextEditingController itemPriceCont = TextEditingController();
  TextEditingController itemDescriptionCont = TextEditingController();

  FocusNode itemImageUrlNode = FocusNode();
  FocusNode itemNameNode = FocusNode();
  FocusNode itemPriceNode = FocusNode();
  FocusNode itemDescriptionNode = FocusNode();


  List<CategoryModel> categoryList = [];

  String? categoryName = '';
  String? categoryId = '';

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.itemsModel != null;

    categoryService.getCategory(showDeletedItem: false).listen((event) {
      categoryList.clear();
      categoryList.addAll(event);
      if (isUpdate) {
        categoryName = widget.itemsModel!.categoryName;
      } else {
        categoryName = categoryList[0].categoryName;
        categoryId = categoryList[0].id;
      }
      setState(() {});
    });

    if (isUpdate) {
      itemNameCont.text = widget.itemsModel!.itemName!;
      itemPriceCont.text = widget.itemsModel!.itemPrice.toString();
      itemDescriptionCont.text = widget.itemsModel!.description!;
      categoryId = widget.itemsModel!.categoryId;
      itemImageUrlCont.text = widget.itemsModel!.image!;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "Add item details",
        actions: [
          TextButton(
            child: Text("Save", style: primaryTextStyle()),
            onPressed: () {
              if (getBoolAsync(IS_TESTER)) {
                finish(context);
                return toast("Tester role not allowed to perform this action");
              } else {
                finish(context);
                saveItemData();
              }
            },
          ).paddingRight(8)
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select image", style: primaryTextStyle()),
              8.height,
              cachedImage(itemImageUrlCont.text.validate().validate(), fit: BoxFit.cover, width: 150, height: 150).cornerRadiusWithClipRRect(100),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: context.width(),
                          decoration: BoxDecoration(
                            color: context.cardColor,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                          ),
                          child: Text("Item Details", style: primaryTextStyle(size: 18)).paddingAll(16),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Image Url", style: primaryTextStyle()),
                            8.height,
                            AppTextField(
                              controller: itemImageUrlCont,
                              focus: itemImageUrlNode,
                              nextFocus: itemNameNode,
                              textFieldType: TextFieldType.NAME,
                              errorThisFieldRequired : "This field is required",
                              decoration: inputDecoration(hintText: "Image Url"),
                              onFieldSubmitted: (val) {
                                itemImageUrlCont.text = val;
                                setState(() {});
                              },
                            ),
                          ],
                        ).paddingAll(8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Item Name", style: primaryTextStyle()),
                            8.height,
                            AppTextField(
                              controller: itemNameCont,
                              focus: itemNameNode,
                              nextFocus: itemPriceNode,
                              textFieldType: TextFieldType.NAME,
                              errorThisFieldRequired : "This field is required",
                              decoration: inputDecoration(hintText: "Item Name"),
                            ),
                          ],
                        ).paddingAll(8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Price", style: primaryTextStyle()),
                            8.height,
                            AppTextField(
                              controller: itemPriceCont,
                              focus: itemPriceNode,
                              nextFocus: itemDescriptionNode,
                              textFieldType: TextFieldType.NAME,
                              errorThisFieldRequired : "This field is required",
                              decoration: inputDecoration(hintText: "Price"),
                            ),
                          ],
                        ).paddingAll(8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Description", style: primaryTextStyle()),
                            8.height,
                            AppTextField(
                              controller: itemDescriptionCont,
                              focus: itemDescriptionNode,
                              errorThisFieldRequired : "This field is required",
                              textFieldType: TextFieldType.ADDRESS,
                              minLines: 3,
                              decoration: inputDecoration(hintText: "Description"),
                            ),
                          ],
                        ).paddingAll(8),
                      ],
                    ),
                  ).expand(),
                  16.width,
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: context.width(),
                          decoration: BoxDecoration(
                            color: context.cardColor,
                            border: Border.all(color: context.cardColor),
                            borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                          ),
                          child: Text("Item Category", style: primaryTextStyle(size: 18)).paddingAll(16),
                        ),
                        SingleChildScrollView(
                          controller: controller,
                          child: Column(
                            children: categoryList.map((e) {
                              return RadioListTile(
                                value: e.categoryName,
                                groupValue: categoryName,
                                onChanged: (dynamic val) {
                                  categoryName = val;
                                  categoryId = e.id;
                                  setState(() {});
                                },
                                title: Text(e.categoryName.validate(), style: primaryTextStyle()),
                              );
                            }).toList(),
                          ).paddingAll(8),
                        ),
                      ],
                    ),
                  ).expand(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveItemData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ItemsModel data = ItemsModel();

      data.itemName = itemNameCont.text.trim();
      data.itemPrice = itemPriceCont.text.trim().toInt();
      data.description = itemDescriptionCont.text.trim();
      data.categoryId = categoryId;
      data.categoryName = categoryName;
      if (itemImageUrlCont.text.isNotEmpty) {
        data.image = itemImageUrlCont.text.trim();
      }

      if (isUpdate) {
        data.id = widget.itemsModel!.id;
        data.storeId = widget.itemsModel!.storeId;
        data.storeName = widget.itemsModel!.storeName;
        data.inStock = widget.itemsModel!.inStock;
        data.createdAt = widget.itemsModel!.createdAt;
        data.updatedAt = DateTime.now();
        data.isDeleted = widget.itemsModel!.isDeleted;

        itemsService.updateDocument(data.toJson(), widget.itemsModel!.id).then((value) {
          //
        }).catchError((error) {
          toast(error.toString());
        });
      } else {
        if (getBoolAsync(IS_ADMIN)) {
          data.storeId = widget.storeModel!.id;
          data.storeName = widget.storeModel!.storeName;
        } else {
          data.storeId = getStringAsync(STORE_ID);
          data.storeName = getStringAsync(STORE_NAME);
        }

        data.inStock = true;
        data.createdAt = DateTime.now();
        data.updatedAt = DateTime.now();
        data.isDeleted = false;

        itemsService.addDocument(data.toJson()).then((value) {
          //
        }).catchError((error) {
          toast(error.toString());
        });
      }
      finish(context);
    }
  }
}
