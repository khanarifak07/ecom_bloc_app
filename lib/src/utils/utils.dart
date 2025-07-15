import 'dart:convert';

import 'package:ecom_app_bloc/src/models/quotes_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static late SharedPreferences _sharedPreferences;

  static Future<void> initSF() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  //save quote
  static void saveQoutes(List<QuotesModel> quotes) {
    //List<models> --> List<String>
    final quotesString = quotes.map((e) => jsonEncode(e.toJson())).toList();
    _sharedPreferences.setStringList('quotes', quotesString);
    //
  }

  static List<QuotesModel>? getQuotes() {
    //List<String> --> List<Model>
    List<String>? quotesString = _sharedPreferences.getStringList('quotes');
    if (quotesString != null) {
      return quotesString
          .map((e) => QuotesModel.fromJson(jsonDecode(e)))
          .toList();
    }
    return null;
  }

  static bool isQuoteAlreadySaved(QuotesModel quote) {
    final savedQuotes = getQuotes() ?? [];
    return savedQuotes.any((e) => e.id == quote.id);
  }

  //clear quotes
  static void clearSavedQuotes() {
    _sharedPreferences.remove('quotes');
  }

  static void removeQuoteByIndex(int index) {
    final data = getQuotes() ?? [];
    if (index >= 0 && index < data.length) {
      data.removeAt(index);
      saveQoutes(data);
    }
  }

  //save theme
  static saveCurrentTheme(bool isDarkMode) {
    _sharedPreferences.setBool('isDarkMode', isDarkMode);
  }

  //get current theme
  static bool getCurrentTheme() {
    return _sharedPreferences.getBool('isDarkMode') ?? false;
  }

  //snackbar
  static void showSuccessSnackbar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Durations.medium2,
        content: Text(title, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  static void showFailureSnackbar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: Durations.medium2,
        content: Text(title, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
