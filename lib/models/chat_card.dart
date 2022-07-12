class ChatCardModel {
  String lastMessage;
  String userId;
  String workerId;
  String workerPicture;
  String firstName;
  String lastName;

  ChatCardModel({
    required this.firstName,
    required this.lastMessage,
    required this.lastName,
    required this.userId,
    required this.workerId,
    required this.workerPicture,
  });
}
