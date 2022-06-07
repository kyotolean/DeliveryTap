import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:deliverytap_admin/main.dart';
import 'package:deliverytap_admin/models/CategoryModel.dart';
import 'package:deliverytap_admin/utils/Colors.dart';
import 'package:deliverytap_admin/utils/Common.dart';
import 'package:deliverytap_admin/utils/Constants.dart';
import 'package:deliverytap_admin/utils/ModelKeys.dart';
import 'package:nb_utils/nb_utils.dart';

class NewCategoryDialog extends StatefulWidget {
  static String tag = '/NewCategoryDialog';

  final CategoryModel? data;

  NewCategoryDialog({this.data});

  @override
  NewCategoryDialogState createState() => NewCategoryDialogState();
}

class NewCategoryDialogState extends State<NewCategoryDialog> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController nameCont = TextEditingController();
  TextEditingController imageCont = TextEditingController();
  TextEditingController inputPrimaryColor = TextEditingController();

  Color pickerColor = colorPrimary;

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.data != null;

    if (isUpdate) {
      nameCont.text = widget.data!.categoryName.validate();
      imageCont.text = widget.data!.image.validate();
      inputPrimaryColor.text = widget.data!.color.validate();
      pickerColor = widget.data!.color.toColor();
    } else {
      inputPrimaryColor.text = "#FF674FFF";
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> addCategory() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      appStore.setLoading(true);

      Map<String, dynamic> data = {
        CategoryKey.categoryName: nameCont.text,
        CategoryKey.color: inputPrimaryColor.text,
        CategoryKey.image: imageCont.text,
        CategoryKey.isDeleted: false,
        TimeDataKey.updatedAt: DateTime.now(),
      };

      if (isUpdate) {
        await categoryService.updateDocument(data, widget.data!.id.validate()).then((value) {
          finish(context);
        }).catchError((e) {
          toast(e.toString());
          log(e.toString());
        });
      } else {
        await categoryService.addDocument(data).then((value) {
          finish(context);
        }).catchError((e) {
          toast(e.toString());
          log(e.toString());
        });
      }

      appStore.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Category", style: boldTextStyle()),
              16.height,
              AppTextField(
                controller: nameCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(labelText: "Category Name"),
                autoFocus: true,
                errorThisFieldRequired: "This field is required",
              ),
              16.height,
              AppTextField(
                controller: imageCont,
                textFieldType: TextFieldType.OTHER,
                decoration: inputDecoration(labelText: "Image Url"),
                keyboardType: TextInputType.url,
                validator: (s) {
                  if (s!.isEmpty) return  "This field is required";
                  if (!s.validateURL()) return "Invalid URL";
                  return null;
                },
              ),
              16.height,
              Row(
                children: [
                  AppTextField(
                    controller: inputPrimaryColor,
                    textFieldType: TextFieldType.OTHER,
                    onFieldSubmitted: (s) {
                      try {
                        pickerColor = s.toColor();
                        inputPrimaryColor.text = pickerColor.toHex(includeAlpha: true).toUpperCase();

                        setState(() {});
                      } catch (e) {
                        print(e);
                      }
                    },
                    decoration: inputDecoration(labelText: "Category Color").copyWith(
                      suffixIcon: Text("Pick Color", style: primaryTextStyle()).paddingAll(8).onTap(() {
                        showInDialog(
                          context,
                          backgroundColor: context.cardColor,
                          title: Text("Select Color"),
                          actions: [
                            TextButton(
                              child: Text("Done", style: boldTextStyle()),
                              onPressed: () {
                                inputPrimaryColor.text = pickerColor.toHex(includeAlpha: true).toUpperCase();
                                finish(context);
                              },
                            )
                          ],
                          child: Container(
                            color: Colors.white24,
                            width: 600,
                            height: 200,
                            child: ColorPicker(
                              pickerColor: pickerColor,
                              enableAlpha: true,
                              displayThumbColor: true,
                              onColorChanged: (color) {
                                setState(() {
                                  pickerColor = color;
                                  inputPrimaryColor.text = pickerColor.toHex(includeAlpha: true).toUpperCase();
                                });
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ).expand(),
                  8.width,
                  Container(
                    decoration: BoxDecoration(color: pickerColor, shape: BoxShape.circle),
                    padding: EdgeInsets.all(20),
                  ),
                ],
              ),
              16.height,
              AppButton(
                text: isUpdate ? "Update" : "Save",
                width: context.width(),
                color: colorPrimary,
                textStyle: primaryTextStyle(color: white),
                padding: EdgeInsets.all(20),
                onTap: () {
                  if (getBoolAsync(IS_TESTER)) {
                    finish(context);
                    return toast("Tester role not allowed to perform this action");
                  } else {
                    addCategory();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
