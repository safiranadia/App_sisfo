class ItemsModel {
  List<ItemModel>? data;

  ItemsModel({
    this.data,
  });
}

class ItemModel {
  int id;
  String codeItem;
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
    required this.codeItem,
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
      name: map['name'] as String,
      categoryId: map['category_id'] as int?,
      image: map['image'] as String?,
      stock: map['stock'] as int?,
      condition: map['condition'] as String?,
      location: map['location'] as String?,
    );
  }
}

