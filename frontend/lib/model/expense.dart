class Expense {
  int id;
  int userId;
  String title;
  double amount;
  String category;
  DateTime date;
  String? notes;

  Expense(
      {required this.id,
      required this.userId,
      required this.title,
      required this.amount,
      required this.category,
      required this.date,
      this.notes});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['ID'],
      userId: json['USER_ID'],
      title: json['TITLE'],
      amount: json['AMOUNT'].toDouble(),
      category: json['CATEGORY'],
      date:DateTime.parse(json['DATE']),
      notes: json['NOTES'],
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'ID': id,
      'USER_ID': userId,
      'TITLE': title,
      'AMOUNT': amount,
      'CATEGORY': category,
      'DATE': date.toIso8601String(), // Convert DateTime to ISO string
      'NOTES': notes,
    };
  }
}
