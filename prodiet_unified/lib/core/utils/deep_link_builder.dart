class DeepLinkBuilder {
  // Ingredient shopping links
  static Uri blinkit(String ingredient) =>
      Uri.parse('https://blinkit.com/s/?q=${Uri.encodeComponent(ingredient)}');

  static Uri zepto(String ingredient) => Uri.parse(
      'https://www.zepto.com/search?query=${Uri.encodeComponent(ingredient)}');

  static Uri bigbasket(String ingredient) => Uri.parse(
      'https://www.bigbasket.com/ps/?q=${Uri.encodeComponent(ingredient)}');

  static Uri swiggyInstamart(String ingredient) => Uri.parse(
      'https://www.swiggy.com/instamart/search?query=${Uri.encodeComponent(ingredient)}');

  // Can't cook — food order links
  static Uri zomato(String dish) =>
      Uri.parse('https://www.zomato.com/search?q=${Uri.encodeComponent(dish)}');

  static Uri swiggyFood(String dish) => Uri.parse(
      'https://www.swiggy.com/search?query=${Uri.encodeComponent(dish)}');
}
