String switchCategoryToArabic(String category) {
  switch (category) {
    case "Estates":
      return "عقارات";
    case "Vehicles":
      return "مركبات";
    case "Fashion & Beauty":
      return "موضة وجمال";
    case "Mobiles":
      return "موبايلات";
    case "Furniturs":
      return "مفروشات";
    case "Computers":
      return "حواسيب";
    case "Gifts":
      return "هدايا";
    case "Babies stuff":
      return "مستلزمات أطفال";
    case "Motorcycles":
      return "دراجات";
    case "Sport":
      return "رياضة";
    case "Pharmacies":
      return "صيدليات";
    case "Services":
      return "خدمات";
    case "Malls":
      return "محلات";
    case "Cafe":
      return "مقاهي";
    case "Resturant":
      return "مطاعم";
    case "Variants":
      return "منوعة";
  }
  return "";
}

String switchLocationToArabic(String location) {
  switch (location) {
    case "Hama":
      return "حماة";
    case "Homs":
      return "حمص";
    case "Raqqa":
      return "الرّقة";
    case "Dier Alzour":
      return "دير الزور";
    case "Al-hasaka":
      return "الحسكة";
    case "Al-Qunaitra":
      return "القنيطرة";
    case "Swaidaa":
      return "السويداء";
    case "Damascus":
      return "دمشق";
    case "Aleppo":
      return "حلب";
    case "Daraa":
      return "درعا";
    case "Tartous":
      return "طرطوس";
    case "Lattakia":
      return "اللاذقية";
    case "Idlib":
      return "إدلب";
    case "other":
      return "أخرى";
  }
  return "أخرى";
}
