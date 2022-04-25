class Cart {
  final String foodId, image, restaurantId;
  final String name;
  final double price;
  final int quantity;

  late double total;
  List<String> compliments = [];

  Cart(
      {required this.foodId,
      required this.price,
      required this.name,
      required this.image,
      required this.quantity,
      required this.restaurantId,
      this.compliments = const []}) {
    total = price;
  }
  toggle(String selection) {
    bool remove = false;

    for (String data in compliments) {
      if (data == selection) {
        remove = true;
      }
    }
    if (remove) {
      compliments.removeWhere((element) => element == selection);
    } else {
      compliments.add(selection);
    }
  }
}
