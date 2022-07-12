class ChatCardModel {
  String lastMessage;
  String userId;
  String userPicture;
  String firstName;
  String lastName;

  ChatCardModel({
    required this.firstName,
    required this.lastMessage,
    required this.lastName,
    required this.userId,
    required this.userPicture,
  });
}
