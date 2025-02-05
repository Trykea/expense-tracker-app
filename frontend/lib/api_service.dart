import 'dart:convert';
import 'package:http/http.dart' as http;

import 'model/expense.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.106:3000';

  // Login
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login : ${response.body}');
    }
  }

  // sign up
  static Future<Map<String, dynamic>> signup(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      // Use 201 for created
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to signup: ${response.body}');
    }
  }

  // Add Expense
  static Future<Map<String, dynamic>> addExpense(
    String token,
    Expense expense,
      // Pass the Expense model instead of individual fields
  ) async {


    final response = await http.post(
      Uri.parse('$baseUrl/expenses'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
        // Ensure you're using "Bearer" for token authorization
      },
      body:
          jsonEncode(expense.toJson()), // Use the Expense model's toJson method
    );
    print('Response status: ${response.statusCode}');
    print(jsonEncode(expense.toJson()));

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to add expense');
    }
  }

  // Get Expenses
  static Future<List<Expense>> getExpenses(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/expenses'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Expense> expenses =
          jsonResponse.map((data) => Expense.fromJson(data)).toList();
      return expenses; // Convert JSON to List<Expense>
    } else {
      throw Exception('Failed to fetch expenses');
    }
  }

  // Delete Expense
  static Future<void> deleteExpense(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/expenses/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete expense');
    }
  }
  //update expense
  static Future<Map<String, dynamic>> updateExpense(
      String token,
      int expenseId, // The ID of the expense to be updated
      Expense expense, // The updated Expense model
      ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/expenses/$expenseId'), // URL with the expense ID
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token', // Use Bearer for the token
      },
      body: jsonEncode(expense.toJson()), // Pass the updated expense model
    );

    print('Response status: ${response.statusCode}');
    print(jsonEncode(expense.toJson()));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.body);
      throw Exception('Failed to update expense');
    }
  }

}
