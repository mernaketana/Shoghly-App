class WorkerProject {
  final List<dynamic>? urls;
  final String desc;
  String? projectId;
  DateTime? createdAt;
  DateTime? updatedAt;

  WorkerProject(
      {required this.desc,
      required this.urls,
      this.createdAt,
      this.updatedAt,
      this.projectId});
}
