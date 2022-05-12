class Comment {
  final String userId;
  final String comment;
  final double? rate;
  final String workerId;
  final DateTime createdAt;

  Comment(
      {required this.comment,
      this.rate,
      required this.userId,
      required this.workerId,
      required this.createdAt});
}
