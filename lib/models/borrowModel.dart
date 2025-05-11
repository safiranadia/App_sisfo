class BorrowsModel {
  List<Borrow> data;

  BorrowsModel({
    required this.data,
  });

  static fromMap(Map<String, dynamic> borrow) {}
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
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
