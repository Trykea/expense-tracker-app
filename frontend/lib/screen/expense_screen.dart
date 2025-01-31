import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/screen/add_expense_screen.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/model/expense.dart';
import 'package:frontend/widget/expense_card.dart';
import 'package:frontend/widget/monthly_expense_grid.dart';
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
  bool _isLoading = true;
  DateTime selectedMonth = DateTime.now();
  bool _isFiltered = false;
  bool _showGridView = false;

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
        _isLoading = false;
        _isFiltered = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _filterExpensesByMonth(DateTime month) {
    setState(() {
      print('Filtering for Month: ${month.year}-${month.month}');
      filteredExpenses = expenses.where((expense) {
        DateTime expenseDate = DateTime.parse(expense.date);
        print('Expense Date: ${expenseDate.year}-${expenseDate.month}');
        return expenseDate.year == month.year && expenseDate.month == month.month;
      }).toList();
      _isFiltered = true;
    });
  }



  void _showMonthPickerModal(BuildContext context) async {
    DateTime? pickedMonth = await showMonthPicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: selectedMonth, // Use selectedMonth as initial date
    );

    if (pickedMonth != null) {
      setState(() {
        selectedMonth = DateTime(pickedMonth.year, pickedMonth.month, 1);
        _filterExpensesByMonth(selectedMonth);
      });
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredExpenses.isEmpty
              ? const Center(child: Text("No expenses for this month"))
              : _showGridView && _isFiltered
                  ? MonthlyExpenseGrid(
                      expenses: filteredExpenses,
                      selectedMonth: selectedMonth,
                    )
                  : ListView.builder(
                      itemCount: filteredExpenses.length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      itemBuilder: (context, index) {
                        final expense = filteredExpenses.reversed
                            .toList()[index]; // Reverse the list
                        return ExpenseCard(
                          expense: expense,
                          onEdit: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Function not availble yet')),
                            );
                          },
                          onDelete: () async {
                            // Show confirmation dialog
                            final confirmDelete = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text('Are you sure you want to delete this expense?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );


                            if (confirmDelete == true) {
                              try {
                                await ApiService.deleteExpense(widget.token, expense.id);
                                _fetchExpense();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Expense deleted successfully')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to delete expense')),
                                );
                              }
                            }
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
              onPressed: () {
                setState(() {
                  _showGridView = !_showGridView;
                });
              },
              icon: Icon(_showGridView ? Icons.list : Icons.grid_view),
              label: Text(_showGridView ? "Show List" : "Show Grid"),
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
