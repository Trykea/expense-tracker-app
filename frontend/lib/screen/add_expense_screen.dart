import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/model/expense.dart';
import 'package:frontend/api_service.dart';

class AddExpenseScreen extends StatefulWidget {
  final String token;
  final int userId;
  const AddExpenseScreen({
    Key? key,
    required this.token,
    required this.userId,
  }) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categories = ['Food', 'Transport', 'Entertainment', 'Others'];
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  String _enteredTitle = '';
  double _selectedAmount = 0.0;
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  String _enteredNotes = '';

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  Future<void> _addExpense() async {
    if (!_formKey.currentState!.validate()) return;

    final expense = Expense(
      userId: widget.userId,
      title: _enteredTitle,
      amount: _selectedAmount,
      category: _selectedCategory,
      date: DateFormat('yyyy-MM-dd').format(_selectedDate),
      notes: _enteredNotes,
    );

    try {
      await ApiService.addExpense(widget.token, expense);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add expense')),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _addExpense,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView.separated(
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return _buildTitleField(theme);
                case 1:
                  return _buildAmountField(theme);
                case 2:
                  return _buildCategoryDropdown(theme);
                case 3:
                  return _buildDatePicker(colorScheme);
                case 4:
                  return _buildNotesField(theme);
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField(ThemeData theme) {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Title',
        prefixIcon: const Icon(Icons.title),
        border: _inputBorder(theme),
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Please enter a title' : null,
      onChanged: (value) => setState(() => _enteredTitle = value),
    );
  }

  Widget _buildAmountField(ThemeData theme) {
    return TextFormField(
      controller: _amountController,
      decoration: InputDecoration(
        labelText: 'Amount',
        prefixIcon: const Icon(Icons.attach_money),
        border: _inputBorder(theme),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Please enter an amount';
        if (double.tryParse(value!) == null) return 'Invalid number';
        return null;
      },
      onChanged: (value) => setState(() => _selectedAmount = double.tryParse(value) ?? 0.0),
    );
  }

  Widget _buildCategoryDropdown(ThemeData theme) {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        prefixIcon: const Icon(Icons.category),
        border: _inputBorder(theme),
      ),
      items: _categories.map((category) => DropdownMenuItem(
        value: category,
        child: Text(category),
      )).toList(),
      onChanged: (value) => setState(() => _selectedCategory = value!),
    );
  }

  Widget _buildDatePicker(ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                DateFormat.yMMMMd().format(_selectedDate),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
              ),
              onPressed: _presentDatePicker,
              child: const Text('Choose Date'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField(ThemeData theme) {
    return TextFormField(
      controller: _notesController,
      decoration: InputDecoration(
        labelText: 'Notes (Optional)',
        prefixIcon: const Icon(Icons.notes),
        border: _inputBorder(theme),
      ),
      maxLines: 2,
      onChanged: (value) => setState(() => _enteredNotes = value),
    );
  }

  OutlineInputBorder _inputBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: theme.colorScheme.outline.withOpacity(0.3),
      ),
    );
  }
}