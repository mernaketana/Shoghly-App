class Commenter {
  final String id;
  final String fname;
  final String lname;
  final String picture;
  final String gender;

  Commenter(
      {required this.id,
      required this.fname,
      required this.lname,
      required this.picture,
      required this.gender});
}

class Comment {
  final Commenter? user;
  final String comment;
  final double? rate;
  final String workerId;
  final DateTime? createdAt;
  final String? reviewId;
  final DateTime? updatedAt;
  final String? userId;

  Comment(
      {required this.comment,
      this.rate,
      this.reviewId,
      this.updatedAt,
      this.user,
      this.userId,
      required this.workerId,
      this.createdAt});
}
