class MessageData {
  final String name, message, senderName, senderId, dateMessage, profilePicture;
  final DateTime messageDate;

  MessageData(
      {required this.name,
      required this.senderName,
      required this.message,
      required this.senderId,
      required this.dateMessage,
      required this.profilePicture,
      required this.messageDate});
}
