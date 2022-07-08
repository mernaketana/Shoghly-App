class Employee {
  final String id;
  final String? categordId;
  String? image;
  String fname;
  String lname;
  int phone;
  String email;
  String password;
  String location;
  DateTime? bDate;
  final String role;
  String gender;
  String address;
  List? reviews;
  int? reviewsCount;

  Employee(
      {required this.id,
      required this.address,
      this.bDate,
      this.categordId,
      required this.fname,
      required this.lname,
      required this.email,
      required this.password,
      this.image,
      required this.gender,
      required this.phone,
      required this.location,
      this.reviews,
      this.reviewsCount,
      required this.role});
}
