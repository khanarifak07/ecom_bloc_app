import 'dart:convert';
import 'dart:developer';

import 'package:ecom_app_bloc/src/models/quotes_model.dart';
import 'package:ecom_app_bloc/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
    getAllQuotes();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        getAllQuotes();
        log('BOTTOM');
      }
    });
  }

  //
  List<QuotesModel> quotesData = [];
  bool hasMore = true;
  int currentOffset = 0;
  int pageSize = 10;
  late ScrollController _scrollController;

  //
  Future<void> getAllQuotes() async {
    try {
      //
      if (!hasMore) return;
      //
      //
      final response = await http.get(
        Uri.parse(ApiService.getAllQuotes(currentOffset)),
      );
      //
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final quotesList = data['quotes'] as List;
        final quotes = quotesList.map((e) => QuotesModel.fromJson(e)).toList();
        //
        if (quotes.length < pageSize) {
          hasMore = false;
        }
        //
        quotesData.addAll(quotes);
        currentOffset += pageSize;
        setState(() {});
      }
    } catch (e) {
      log('Error while getting quotes $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: quotesData.length + (hasMore ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index < quotesData.length) {
            final quote = quotesData[index];
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListTile(
                tileColor: Colors.red.shade100,
                title: Text(quote.quote!, style: TextStyle(fontSize: 16)),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
