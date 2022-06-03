class MessageData {
  final String message, senderId, profilePicture, restaurantId;
  final DateTime messageDate;

  MessageData(
      {required this.restaurantId,
      required this.message,
      required this.senderId,
      required this.profilePicture,
      required this.messageDate});

  @override
  String toString() =>
      'MessageData(restaurantId: $restaurantId, messageDate: $messageDate)';
}
