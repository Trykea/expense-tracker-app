class Expense {
  final int? id;
  int userId;
  String title;
  double amount;
  String category;
  String date;
  String? notes;

  Expense(
      {
        this.id,
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
      date:json['DATE'],
      notes: json['NOTES'],
    );
  }
  Map<String, dynamic> toJson(){
    if (id == null) {
      return {
        'userId': userId,
        'title': title,
        'amount': amount,
        'category': category,
        'date': date, // Convert DateTime to ISO string
        'notes': notes,
      };
    }
    else{
      return {
        'id' : id,
        'userId': userId,
        'title': title,
        'amount': amount,
        'category': category,
        'date': date, // Convert DateTime to ISO string
        'notes': notes,
      };
    }
  }
}
