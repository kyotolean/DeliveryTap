import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:deliverytap_user/main.dart';
import 'package:deliverytap_user/models/StoreReviewModel.dart';
import 'package:deliverytap_user/models/StoreModel.dart';
import 'package:deliverytap_user/services/StoreReviewDBService.dart';
import 'package:deliverytap_user/utils/ChipsChoice.dart';
import 'package:deliverytap_user/utils/Colors.dart';
import 'package:deliverytap_user/utils/Common.dart';
import 'package:deliverytap_user/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class AddReviewScreen extends StatefulWidget {
  static String tag = '/AddReviewScreen';
  final StoreModel? store;

  AddReviewScreen(this.store);

  @override
  AddReviewScreenState createState() => AddReviewScreenState();
}

class AddReviewScreenState extends State<AddReviewScreen> {
  late StoreReviewsDBService storeReviewsDBService;

  int ratings = 0;

  TextEditingController tagCont = TextEditingController();
  List<String> tags = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await 1.milliseconds.delay;

    storeReviewsDBService = StoreReviewsDBService(widget.store!.id);
    setState(() {});
  }

  addReview() async {
    if (ratings == 0) {
      toast("Please give rating");
      return;
    }
    if (tagCont.text.trim().isEmpty) {
      toast("Please write something");
      return;
    }

    appStore.setLoading(true);

    StoreReviewModel reviewModel = StoreReviewModel();

    reviewModel.rating = ratings;
    reviewModel.review = tagCont.text;
    reviewModel.reviewerId = appStore.userId;
    reviewModel.reviewTags = tags;
    reviewModel.storeId = widget.store!.id;
    reviewModel.reviewerImage = appStore.userProfileImage.validate();
    reviewModel.reviewerName = appStore.userFullName;
    reviewModel.reviewerLocation = getStringAsync(USER_CITY_NAME);

    storeReviewsDBService.addDocument(reviewModel.toJson()).then((res) {
      appStore.setLoading(false);

      finish(context);
    }).catchError((error) {
      toast(error.toString());
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Write a review", color: colorPrimary, textColor: Colors.white),
      body: Stack(
        children: [
          Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Rate your experience", style: boldTextStyle()),
                          10.height,
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 0,
                            allowHalfRating: false,
                            tapOnlyMode: true,
                            itemCount: 5,
                            maxRating: 5,
                            glow: false,
                            unratedColor: grey,
                            itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                            itemSize: 40,
                            onRatingUpdate: (rating) {
                              print(rating);
                              ratings = rating.toInt();
                              setState(() {});
                            },
                          ),
                        ],
                      ).paddingAll(16),
                      Divider(),
                      Column(
                        children: <Widget>[
                          Container(
                            child: Text("Your review helps other"),
                            padding: EdgeInsets.all(16),
                          ).visible(ratings == 0),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Text("Share your experience!", style: boldTextStyle()),
                                    4.height,
                                    TextField(
                                      decoration: InputDecoration(
                                        hintText: "Search tag or select from below",
                                      ),
                                      onSubmitted: (s) {
                                        tags.add(s);
                                        setState(() {});
                                      },
                                    ).visible(false),
                                  ],
                                ).paddingAll(16),
                                Container(
                                  child: ChipsChoice<String>.multiple(
                                    value: tags,
                                    options: ChipsChoiceOption.listFrom<String, String>(
                                      source: ratings >= 4 ? highRateTags() : lowRateTags(),
                                      value: (i, v) => v,
                                      label: (i, v) => v,
                                    ),
                                    onChanged: (val) => setState(() => tags = val),
                                    isWrapped: true,
                                    itemConfig: ChipsChoiceItemConfig(),
                                  ),
                                ),
                                Divider(thickness: 3, height: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Write a review", style: boldTextStyle()),
                                    4.height,
                                    TextField(
                                      controller: tagCont,
                                      style: primaryTextStyle(),
                                      decoration: InputDecoration(hintText: "Write detailed review here", hintStyle: primaryTextStyle()),
                                      textCapitalization: TextCapitalization.sentences,
                                      keyboardType: TextInputType.multiline,
                                      minLines: 4,
                                      maxLines: 10,
                                    ),
                                  ],
                                ).paddingAll(16),
                              ],
                            ),
                          ).visible(ratings != 0),
                        ],
                      ),
                    ],
                  ),
                  AppButton(
                    onTap: () {
                      addReview();
                    },
                    color: colorPrimary,
                    width: context.width() - 10,
                    child: Text("Submit", style: primaryTextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
