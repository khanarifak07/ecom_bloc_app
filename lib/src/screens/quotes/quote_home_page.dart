import 'dart:async';

import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_bloc.dart';
import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_event.dart';
import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_state.dart';
import 'package:ecom_app_bloc/src/providers/theme/theme.dart';
import 'package:ecom_app_bloc/src/screens/quotes/saved_quotes_wrapper.dart';
import 'package:ecom_app_bloc/src/screens/quotes/widgets/my_drawer.dart';
import 'package:ecom_app_bloc/src/screens/quotes/widgets/quote_tile.dart';
import 'package:ecom_app_bloc/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuoteHomePage extends StatelessWidget {
  const QuoteHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var timer = context.read<QuotesBloc>().debounce;
    var authorNames = context.read<QuotesBloc>().authorNames;
    var searchCtrl = context.read<QuotesBloc>().searchCtrl;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? MaterialTheme.darkMediumContrastScheme().surface
          : MaterialTheme.lightMediumContrastScheme().surface,
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          context.read<QuotesBloc>().add(GetRandomQuotesEvent());
        },
      ),
      appBar: AppBar(
        leadingWidth: 25,
        // backgroundColor: Colors.white,
        // surfaceTintColor: Colors.white,
        actions: [
          PopupMenuButton(
            color: Colors.white,
            initialValue: 'All',
            tooltip: 'Filter By Author',
            icon: Icon(Icons.sort_rounded),
            itemBuilder: (context) {
              return authorNames
                  .map(
                    (e) => PopupMenuItem(
                      value: e,
                      child: Text(e, style: TextStyle(color: Colors.black)),
                    ),
                  )
                  .toList();
            },
            onSelected: (value) {
              context.read<QuotesBloc>().add(GetQuotesByAuthorEvent(value));
            },
          ),
          IconButton(
            tooltip: 'Saved Quotes',
            onPressed: () {
              SavedQuotesWrapper.route(context);
            },
            icon: Icon(Icons.bookmark_outline),
          ),
        ],
        title: SearchBar(
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 14, color: Colors.black),
          ),
          controller: searchCtrl,
          trailing: [
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {
                searchCtrl.clear();
                context.read<QuotesBloc>().add(ClearFilterEvent());
              },
              icon: Icon(Icons.clear, color: Colors.black54),
            ),
          ],
          leading: Icon(Icons.search, color: Colors.black54),
          hintText: 'Search By Quote And Author',
          hintStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 14, color: Colors.black),
          ),
          elevation: WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(Colors.green.shade50),
          onChanged: (query) {
            if (timer?.isActive ?? false) timer?.cancel();
            timer = Timer(Duration(milliseconds: 300), () {
              context.read<QuotesBloc>().add(SearchQuotesEvent(query));
            });
          },
        ),
      ),
      // backgroundColor: Colors.white,
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
          final bloc = context.read<QuotesBloc>();
          if (state is QuotesLoadingState && state.isInitialLoad) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is QuotesLoadedState ||
              state is SavedQuotesSucessState ||
              (state is QuotesLoadingState && !state.isInitialLoad)) {
            final quotes = (state is QuotesLoadedState)
                ? state.quotes
                : bloc.quotesData;
            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 100 &&
                    bloc.hasMore &&
                    !bloc.isLoading) {
                  context.read<QuotesBloc>().add(GetAllQuotesEvent());
                }
                return false;
              },
              child: ListView.builder(
                // controller: _scrollController,
                // itemCount: quotes.length + (bloc.hasMore ? 1 : 0),
                itemCount:
                    quotes.length + ((!bloc.isFilter && bloc.hasMore) ? 1 : 0),

                itemBuilder: (context, index) {
                  if (index < quotes.length) {
                    //for quotes key
                    if (bloc.quotesKey.length <= index) {
                      bloc.quotesKey.add(GlobalKey());
                    }
                    //
                    return RepaintBoundary(
                      key: bloc.quotesKey[index],
                      child: QuoteTile(
                        quote: quotes[index],
                        index: index,
                        globalKey: bloc.quotesKey[index],
                      ),
                    );
                    //
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            );
          }

          if (state is QuotesFailureState) {
            return Center(child: Text(state.errorMessage));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
