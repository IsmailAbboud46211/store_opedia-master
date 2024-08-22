import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

List<String> categories = [
  LocaleKeys.estates.tr(),
  LocaleKeys.vehicles.tr(),
  LocaleKeys.fashion_beauty.tr(),
  LocaleKeys.mobiles.tr(),
  LocaleKeys.furniturs.tr(),
  LocaleKeys.computers.tr(),
  LocaleKeys.gifts.tr(),
  LocaleKeys.babies_stuff.tr(),
  LocaleKeys.motorcycles.tr(),
  LocaleKeys.sport.tr(),
  LocaleKeys.pharmacies.tr(),
  LocaleKeys.services.tr(),
  LocaleKeys.malls.tr(),
  LocaleKeys.resturant.tr(),
  LocaleKeys.cafe.tr(),
  LocaleKeys.variants.tr(),
];

List<String> categoriesEnglish = [
  "Estates",
  "Vehicles",
  "Fashion & Beauty",
  "Mobiles",
  "Furniturs",
  "Computers",
  "Gifts",
  "Babies stuff",
  "Motorcycles",
  "Sport",
  "Pharmacies",
  "Services",
  "Malls",
  "Resturant",
  "Cafe",
  "Variants",
];

List<String> categoriesArabic = [
  "عقارات",
  "مركبات",
  "موضة و جمال",
  "موبايلات",
  "مفروشات",
  "حواسيب",
  "هدايا",
  "مستلزمات أطفال",
  "دراجات",
  "رياضة",
  "صيدليات",
  "خدمات",
  "محلات",
  "مطاعم",
  "مقاهي",
  "منوعة",
];

IconData? categoryIcon(String category) {
  switch (category) {
    case "عقارات":
    case "Estates":
      return FontAwesomeIcons.building;
    case "مركبات":
    case "Vehicles":
      return FontAwesomeIcons.truck;
    case "موضة و جمال":
    case "Fashion & Beauty":
      return FontAwesomeIcons.person;
    case "موبايلات":
    case "Mobiles":
      return FontAwesomeIcons.mobile;
    case "مفروشات":
    case "Furniturs":
      return FontAwesomeIcons.couch;
    case "حواسيب":
    case "Computers":
      return FontAwesomeIcons.laptop;
    case "هدايا":
    case "Gifts":
      return FontAwesomeIcons.gift;
    case "مستلزمات أطفال":
    case "Babies stuff":
      return FontAwesomeIcons.baby;
    case "دراجات":
    case "Motorcycles":
      return FontAwesomeIcons.motorcycle;
    case "رياضة":
    case "Sport":
      return FontAwesomeIcons.volleyball;
    case "صيدليات":
    case "Pharmacies":
      return FontAwesomeIcons.capsules;
    case "خدمات":
    case "Services":
      return FontAwesomeIcons.servicestack;
    case "محلات":
    case "Malls":
      return FontAwesomeIcons.shop;
    case "مقاهي":
    case "Cafe":
      return FontAwesomeIcons.mugSaucer;
    case "مطاعم":
    case "Resturant":
      return FontAwesomeIcons.utensils;
    case "منوعة":
    case "Variants":
      return FontAwesomeIcons.globe;
  }
  return null;
}
