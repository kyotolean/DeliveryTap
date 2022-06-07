import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';

import 'StatisticsItemWidget.dart';

Widget cachedImage(String? url, {double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true, double? radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
      },
    );
  } else {
    return Image.asset(url!, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset(
    'images/placeholder.jpg',
    height: height,
    width: width,
    fit: fit ?? BoxFit.cover,
    alignment: alignment ?? Alignment.center,
  ).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

Widget streamBuilderWidget({Stream? stream, String? title}) {
  return StreamBuilder(
    stream: stream,
    builder: (_, AsyncSnapshot? snap) {
      if (snap!.hasData) {
        return StatisticsItemWidget(count: snap.data!.length, title: title);
      } else {
        return SizedBox();
      }
    },
  );
}
