class Cart {
  final String foodId, image, restaurantId;

  final double price;
  final int quantity;

  late double total;

  Cart(
      {required this.foodId,
      required this.price,
      required this.image,
      required this.quantity,
      required this.restaurantId}) {
    total = price;
  }
}
