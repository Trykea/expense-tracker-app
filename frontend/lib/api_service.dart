import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://172.16.0.114:3000';

  // Login
  static Future<Map<String, dynamic>> login(String username, String password) async {
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
  static Future<Map<String, dynamic>> signup(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) { // Use 201 for created
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to signup: ${response.body}');
    }
  }

  // Add Expense
  static Future<Map<String, dynamic>> addExpense(String token, double amount, String category, String date, String notes) async {
    final response = await http.post(
      Uri.parse('$baseUrl/expenses'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode({
        'amount': amount,
        'category': category,
        'date': date,
        'notes': notes,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add expense');
    }
  }

  // Get Expenses
  static Future<List<dynamic>> getExpenses(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/expenses'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
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
}