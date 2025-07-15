import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_bloc.dart';
import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_event.dart';
import 'package:ecom_app_bloc/src/screens/quotes/saved_quotes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedQuotesWrapper extends StatelessWidget {
  const SavedQuotesWrapper({super.key});

  static route(context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => SavedQuotesWrapper()),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuotesBloc()..add(GetAllSavedQuotesEvent()),
      child: SavedQuotes(),
    );
  }
}
