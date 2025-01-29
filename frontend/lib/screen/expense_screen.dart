import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/model/expense.dart';

class ExpenseScreen extends StatefulWidget {
  ExpenseScreen({super.key, required this.token});

  String token;

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  List<Expense> expenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExpense();
  }

  Future<void> _fetchExpense() async {
    try {
      String token = widget.token;
      List<Expense> fetchedExpenses = await ApiService.getExpenses(token);
      setState(() {
        expenses = fetchedExpenses;
        isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense list'),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return Card(
            elevation: 6,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Circle Avatar with Amount
                  CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(expense.amount.toString()),
                    ),
                  ),
                  // Expense details
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            expense.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(DateFormat('dd/MM/yyyy')
                                  .format(expense.date)),
                              Text(expense.category),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(expense.notes.toString()),
                        ],
                      ),
                    ),
                  ),
                  // Delete and Edit buttons
                  Column(
                    children: [
                      SizedBox(
                          // width: 80.0, // Fixed width for both buttons
                          height: 50.0, // Same height for both buttons
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              // backgroundColor: Colors.red,
                              side: BorderSide(color: Colors.red),
                              // Border color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30.0), // Rounded corners
                              ),
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )),
                      SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                          height: 50.0,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              // backgroundColor: Colors.blue,
                              side: BorderSide(color: Colors.blueAccent),
                              // Border color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30.0),
                              ),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.blueAccent,
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
