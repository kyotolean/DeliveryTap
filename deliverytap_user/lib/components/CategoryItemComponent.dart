import 'package:flutter/material.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/models/CategoryModel.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/screens/StoreByCategoryScreen.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryItemComponent extends StatefulWidget {
  final CategoryModel? category;

  CategoryItemComponent({this.category});

  @override
  _CategoryItemComponentState createState() => _CategoryItemComponentState();
}

class _CategoryItemComponentState extends State<CategoryItemComponent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 110,
            width: 130,
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: getColorFromHex(widget.category!.color.validate(), defaultColor: Colors.black),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  widget.category!.categoryName.validate(),
                  style: primaryTextStyle(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            image: DecorationImage(image: Image.network(widget.category!.image.validate()).image, fit: BoxFit.cover),
            shape: BoxShape.circle,
            color: Colors.transparent,
            boxShadow: defaultBoxShadow(spreadRadius: 0.0, blurRadius: 0.0),
          ),
        ),
      ],
    ).onTap(() {
      hideKeyboard(context);
      StoreByCategoryScreen(catName: widget.category!.categoryName.validate()).launch(context);
    }, highlightColor: scaffoldColorDark).paddingLeft(16);
  }
}
