import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/model/expense.dart';

class MonthlyExpenseGrid extends StatelessWidget {
  final List<Expense> expenses;
  final DateTime selectedMonth;

  const MonthlyExpenseGrid({
    super.key,
    required this.expenses,
    required this.selectedMonth,
  });

  Map<DateTime, double> _calculateDailyTotals() {
    final Map<DateTime, double> dailyTotals = {};

    final int daysInMonth = DateUtils.getDaysInMonth(
      selectedMonth.year,
      selectedMonth.month,
    );

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(selectedMonth.year, selectedMonth.month, day);
      dailyTotals[date] = 0.0;
    }

    for (final expense in expenses) {
      final expenseDate = DateTime.parse(expense.date);

      if (expenseDate.year == selectedMonth.year &&
          expenseDate.month == selectedMonth.month) {
        final dayStart =
        DateTime(expenseDate.year, expenseDate.month, expenseDate.day);
        dailyTotals[dayStart] = (dailyTotals[dayStart] ?? 0.0) + expense.amount;
      }
    }

    return dailyTotals;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dailyTotals = _calculateDailyTotals();

    final daysInMonth =
    DateUtils.getDaysInMonth(selectedMonth.year, selectedMonth.month);
    final sortedDays = List.generate(
      daysInMonth,
          (index) => DateTime(selectedMonth.year, selectedMonth.month, index + 1),
    );

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8, // More space between items
                mainAxisSpacing: 8,
                childAspectRatio: 0.9, // Adjusted to make squares look better
              ),
              itemCount: daysInMonth,
              itemBuilder: (context, index) {
                final date = sortedDays[index];
                final total = dailyTotals[date] ?? 0.0;
                final isCurrentDay = date.day == DateTime.now().day &&
                    date.month == DateTime.now().month;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: isCurrentDay
                        ? LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.3),
                        theme.colorScheme.primary.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                    color: isCurrentDay
                        ? null
                        : theme.colorScheme.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8), // Adjusted padding
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('d').format(date),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4), // Improved spacing
                      Text(
                        total > 0 ? '\$${total.toStringAsFixed(2)}' : '-',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: total > 0
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
