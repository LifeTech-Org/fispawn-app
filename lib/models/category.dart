class Category {
  Category(
      {required this.name,
      required this.imgURL,
      required this.noOfParticipants});
  String name;
  String imgURL;
  int noOfParticipants;

  factory Category.fromJSON(Map<String, dynamic> data) {
    return Category(
        name: data['name'],
        imgURL: data['imgURL'],
        noOfParticipants: data['noOfParticipants']);
  }
}
