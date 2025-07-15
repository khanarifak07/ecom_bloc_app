import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_bloc.dart';
import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_state.dart';
import 'package:ecom_app_bloc/src/screens/quotes/widgets/quote_tile.dart';
import 'package:ecom_app_bloc/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedQuotes extends StatelessWidget {
  const SavedQuotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SAVED QUOTES')),
      backgroundColor: Colors.white,
      body: BlocConsumer<QuotesBloc, QuotesState>(
        listener: (context, state) {
          if (state is SavedQuotesSucessState) {
            Utils.showSuccessSnackbar(context, 'Quotes Saved Successfully');
          }
          if (state is SavedQuotesRemovedState) {
            Utils.showFailureSnackbar(context, 'Quotes Removed Successfully');
          }
        },
        builder: (context, state) {
          if (state is SavedQuotesLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is SavedQuotesLoadedState) {
            return ListView.builder(
              itemCount: state.quotes.length,
              itemBuilder: (BuildContext context, int index) {
                return QuoteTile(quote: state.quotes[index], index: index);
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
