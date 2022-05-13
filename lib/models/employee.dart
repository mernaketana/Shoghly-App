// class PlaceLocation {
//   final double latitude;
//   final double longitude;
//   final String? address;

//   const PlaceLocation(
//       {required this.latitude, required this.longitude, this.address});
// }

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
  String address;

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
      required this.phone,
      required this.location,
      required this.role});
}
