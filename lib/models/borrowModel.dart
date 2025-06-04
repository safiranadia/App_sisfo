import 'package:app_sisfo/models/itemModel.dart';

class BorrowsModel {
  List<Borrow> data;

  BorrowsModel({required this.data});

  factory BorrowsModel.fromList(List<dynamic> list) {
    return BorrowsModel(
      data: list.map((item) => Borrow.fromMap(item)).toList(),
    );
  }
}

class Borrow {
  int id;
  int userId;
  int itemId;
  int quantity;
  DateTime borrowDate;
  String purposes;
  String status;
  int isApproved;
  ItemModel? item;
  DateTime createdAt;
  DateTime updatedAt;

  Borrow({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.quantity,
    required this.borrowDate,
    required this.purposes,
    required this.status,
    required this.isApproved,
    this.item,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Borrow.fromMap(Map<String, dynamic> map) {
    return Borrow(
      id: map['id'],
      userId: map['user_id'],
      itemId: map['item_id'],
      quantity: map['quantity'],
      borrowDate: DateTime.parse(map['borrow_date']),
      purposes: map['purposes'],
      status: map['status'],
      isApproved: map['is_approved'],
      item: map['item'] != null ? ItemModel.fromMap(map['item']) : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
