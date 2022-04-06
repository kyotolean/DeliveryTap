import 'package:flutter/material.dart';
import 'package:deliverytap_delivery/components/ReviewItemWidget.dart';
import 'package:deliverytap_delivery/main.dart';
import 'package:deliverytap_delivery/model/ReviewModel.dart';
import 'package:deliverytap_delivery/utils/Colors.dart';
import 'package:deliverytap_delivery/utils/Common.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewScreen extends StatefulWidget {
  @override
  ReviewScreenState createState() => ReviewScreenState();
}

class ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (appStore.isDarkMode) {
      setStatusBarColor(scaffoldColorDark);
    } else {
      setStatusBarColor(Colors.white);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget('Review', showBack: false),
        body: StreamBuilder<List<ReviewModel>>(
          stream: reviewService.restaurantOrderServices(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    16.height,
                    Text('Review not found', style: boldTextStyle()).center(),
                  ],
                ).center();
              }
              return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  int ratings = snapshot.data![index].rating.validate();

                  return ReviewItemWidget(reviewModel: snapshot.data![index], ratings: ratings);
                },
              );
            } else {
              return snapWidgetHelper(snapshot);
            }
          },
        ),
      ),
    );
  }
}
