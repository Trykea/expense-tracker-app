import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/screen/add_expense_screen.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/model/expense.dart';
import 'package:frontend/widget/expense_card.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ExpenseScreen extends StatefulWidget {
  ExpenseScreen({super.key, required this.token});

  final String token;

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  List<Expense> expenses = [];
  List<Expense> filteredExpenses = [];
  bool isLoading = true;
  DateTime selectedMonth = DateTime.now();
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _fetchExpense();
  }

  Future<void> _fetchExpense() async {
    try {
      List<Expense> fetchedExpenses =
          await ApiService.getExpenses(widget.token);
      setState(() {
        expenses = fetchedExpenses;
        filteredExpenses = List.from(fetchedExpenses);
        isLoading = false;
        _isFiltered = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _filterExpensesByMonth(DateTime month) {
    setState(() {
      filteredExpenses = expenses.where((expense) {
        DateTime expenseDate = DateTime.parse(expense.date);
        return expenseDate.year == month.year &&
            expenseDate.month == month.month;
      }).toList();
      _isFiltered = true;
    });
  }

  void _showMonthPickerModal(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? selectedMonth = await showMonthPicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: now,
    );

    if (selectedMonth != null) {
      _filterExpensesByMonth(selectedMonth);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense List'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout), // Change to your desired icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (_isFiltered)
            IconButton(
              icon: Icon(Icons.filter_alt_off),
              onPressed: _fetchExpense,
              // padding: EdgeInsets.only(right: 20),
            ),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {
              _showMonthPickerModal(context);
            },
            padding: EdgeInsets.only(right: 20),

          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredExpenses.isEmpty
              ? const Center(child: Text("No expenses for this month"))
              : ListView.builder(
                  itemCount: filteredExpenses.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemBuilder: (context, index) {
                    final expense = filteredExpenses.reversed
                        .toList()[index]; // Reverse the list
                    return ExpenseCard(
                      expense: expense,
                      onEdit: () {
                        // Edit action
                      },
                      onDelete: () {
                        // Delete action
                      },
                    );
                  },
                ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isFiltered)
            FloatingActionButton.extended(
              onPressed: ()  {

              },
              icon: const Icon(Icons.sort),
              label: const Text("Display as grid"),
            ),
          if (_isFiltered)
            SizedBox(
              height: 12,
            ),
          FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddExpenseScreen(
                  token: widget.token,
                  userId: expenses[0].userId,
                ),
              ));

              if (result == true) {
                _fetchExpense();
              }
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Expense"),
          ),
        ],
      ),
    );
  }
}
