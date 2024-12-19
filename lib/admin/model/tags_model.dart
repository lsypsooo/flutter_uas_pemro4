class TagsModel {
  final int id_tags;
  final String name;

  TagsModel({
    required this.id_tags,
    required this.name,
  });

  factory TagsModel.fromJson(Map<String, dynamic> json) {
    return TagsModel(
      id_tags: json["id_tags"],
      name: json["name"],
    );
  }

  static List<TagsModel> fromJsonList(List list) {
    return list.map((item) => TagsModel.fromJson(item)).toList();
  }

  /// Prevent overriding toString
  String userAsString() {
    return '#$id_tags $name';
  }

  /// Check equality of two models
  bool isEqual(TagsModel model) {
    return id_tags == model.id_tags;
  }

  @override
  String toString() => name;
}
