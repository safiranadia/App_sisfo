class ItemsModel {
  List<ItemModel>? data;

  ItemsModel({
    this.data,
  });
}

class ItemModel {
  int id;
  String? codeItem;
  String name;
  int? categoryId;
  String? image;
  int? stock;
  String? condition;
  String? location;
  DateTime? createdAt;
  DateTime? updatedAt;

  ItemModel({
    required this.id,
    this.codeItem,
    required this.name,
    this.categoryId,
    this.image,
    this.stock,
    this.condition,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'],
      codeItem: map['code_item'],
      name: map['name'],
      categoryId: map['category_id'],
      image: map['image'],
      stock: map['stock'],
      condition: map['condition'],
      location: map['location'],
    );
  }
}
