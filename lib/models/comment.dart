class Comment {
  final String userId;
  final String comment;
  final double? rate;
  final String workerId;

  Comment(
      {required this.comment,
      this.rate,
      required this.userId,
      required this.workerId});
}
