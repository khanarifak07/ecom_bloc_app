import 'package:ecom_app_bloc/src/models/quotes_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class QuotesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAllQuotesEvent extends QuotesEvent {}

class GetAllSavedQuotesEvent extends QuotesEvent {}

class SaveQuoteEvent extends QuotesEvent {
  final List<QuotesModel> quotes;

  SaveQuoteEvent(this.quotes);
}

class ClearAllSavedQuotesEvent extends QuotesEvent {}

class RemoveQuoteByIndexEvent extends QuotesEvent {
  final int index;
  // final List<QuotesModel> quotes;
  RemoveQuoteByIndexEvent(this.index);

  @override
  List<Object> get props => [index];
}

class GetQuotesByAuthorEvent extends QuotesEvent {
  final String author;
  GetQuotesByAuthorEvent(this.author);
  @override
  List<Object> get props => [author];
}

class ClearFilterEvent extends QuotesEvent {}

class SearchQuotesEvent extends QuotesEvent {
  final String searchQuery;
  SearchQuotesEvent(this.searchQuery);
}

class GetRandomQuotesEvent extends QuotesEvent {}

class SaveQuoteToGalleryEvent extends QuotesEvent {
  final BuildContext context;
  final GlobalKey globalKey;
  SaveQuoteToGalleryEvent(this.context, this.globalKey);

  @override
  List<Object> get props => [context, globalKey];
}

class ShareQuoteEvent extends QuotesEvent {
  final GlobalKey globalKey;
  ShareQuoteEvent(this.globalKey);

  @override
  List<Object> get props => [globalKey];
}
