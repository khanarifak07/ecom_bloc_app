import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_bloc.dart';
import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_event.dart';
import 'package:ecom_app_bloc/src/screens/quotes/quote_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuoteHomePageWrapper extends StatelessWidget {
  const QuoteHomePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuotesBloc()..add(GetAllQuotesEvent()),
      child: QuoteHomePage(),
    );
  }
}
