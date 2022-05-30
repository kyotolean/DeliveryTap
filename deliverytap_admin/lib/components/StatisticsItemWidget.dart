import 'package:flutter/material.dart';
import 'package:deliverytap_admin/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

class StatisticsItemWidget extends StatefulWidget {
  static String tag = '/StatisticsItemWidget';
  final int? count;
  final String? title;

  StatisticsItemWidget({this.count, this.title});

  @override
  StatisticsItemWidgetState createState() => StatisticsItemWidgetState();
}

class StatisticsItemWidgetState extends State<StatisticsItemWidget> {
  bool isHovering = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MouseRegion(
        onEnter: (val) {
          isHovering = true;
          setState(() {});
        },
        onExit: (val) {
          isHovering = false;
          setState(() {});
        },
        child: AnimatedContainer(
          duration: 250.milliseconds,
          padding: EdgeInsets.all(8),
          decoration: boxDecorationWithShadow(
            borderRadius: radius(),
            backgroundColor: isHovering ? colorPrimary : context.cardColor,
            spreadRadius: defaultSpreadRadius,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(color: isHovering ? Colors.white : colorPrimary, borderRadius: BorderRadius.circular(60)),
                child: Icon(Icons.person_outline_rounded, color: isHovering ? colorPrimary : Colors.white, size: 28),
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.title.validate(), style: primaryTextStyle(size: 18, color: isHovering ? Colors.white : colorPrimary), overflow: TextOverflow.ellipsis),
                  Text('${widget.count.validate()}', style: primaryTextStyle(size: 26, color: isHovering ? Colors.white : colorPrimary), overflow: TextOverflow.ellipsis),
                ],
              ).expand(),
            ],
          ).paddingAll(8),
        ),
      ),
    ).paddingAll(8);
  }
}
