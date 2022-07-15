class ChatCardModel {
  String lastMessage;
  String userId;
  String userPicture;
  String firstName;
  String lastName;
  String lastMessageUserId;

  ChatCardModel({
    required this.lastMessageUserId,
    required this.firstName,
    required this.lastMessage,
    required this.lastName,
    required this.userId,
    required this.userPicture,
  });
}
