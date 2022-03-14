
import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';

InputDecoration inputDecoration({String? hintText, String? labelText}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: secondaryTextStyle(),
    labelText: labelText ?? '',
    labelStyle: secondaryTextStyle(),
    counterText: '',
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: textPrimaryColor, width: 0.5)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: textPrimaryColor, width: 0.5)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: textPrimaryColor, width: 0.5)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Colors.red, width: 0.5)),
  );
}