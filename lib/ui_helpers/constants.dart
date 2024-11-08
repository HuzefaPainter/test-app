// ignore_for_file: constant_identifier_names

library constants;

import 'package:flutter/material.dart';

const APP_BLUE = Color(0xff1DA1F2);
const HINT_TEXT_COLOR = Color(0xff949C9E);
const FIELD_BORDER_COLOR = Color(0xffe5e5e5);
const ALMOST_BLACK = Color(0xff323238);

const BORDER_DECORATION =
    OutlineInputBorder(borderSide: BorderSide(color: FIELD_BORDER_COLOR));
const HINT_TEXT_STYLE = TextStyle(
    fontSize: 16,
    height: 1.14,
    fontWeight: FontWeight.w400,
    color: HINT_TEXT_COLOR);
const FORM_TEXT_STYLE = TextStyle(
    fontSize: 16,
    height: 1.14,
    fontWeight: FontWeight.w400,
    color: Color(0xff323238));
