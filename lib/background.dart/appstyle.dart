import 'package:flutter/material.dart';

const Color kGrayCC = Color(0xffCCCCCC);
const Color kBlack = Color(0xff000000);
const Color kWhite = Color(0xffFFFFFF);
const Color kWhiteF32 = Color(0xffF3F2F2);
const Color kGray75 = Color(0xff767575);
const Color kGray4A = Color(0xff4A4A4A);
const Color kGrayD9 = Color(0xffD9D9D9);
const Color kGray55 = Color(0xff555555);
const Color kYellow = Color(0xffFEDF43);
const Color kDarkYellow = Color(0xffDBBC1E);
const Color kGreen = Color(0xff2CC14D);
const Color kRed = Color(0xffEB3F3F);

TextStyle mystyleText(heightsize,textsize,color,boldbool) => TextStyle(color: color,fontSize: heightsize*textsize,fontWeight: boldbool?FontWeight.bold:FontWeight.normal);
