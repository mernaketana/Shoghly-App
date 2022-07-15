class Message {
  String messageId;
  String senderId;
  String recieverId;
  bool isOwner;
  String text;
  bool isRead;
  DateTime createdAt;
  DateTime? updatedAt;

  Message({
    required this.messageId,
    required this.senderId,
    required this.recieverId,
    required this.isOwner,
    required this.text,
    required this.isRead,
    required this.createdAt,
    this.updatedAt,
  });
}
