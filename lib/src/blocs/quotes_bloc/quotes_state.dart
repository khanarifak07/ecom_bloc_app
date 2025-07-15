import 'package:ecom_app_bloc/src/models/quotes_model.dart';
import 'package:equatable/equatable.dart';

// The abstract keyword in Dart means you cannot create an instance of this class directly.
// It is meant to be extended or implemented by other classes, not used on its own.
// e.g. --> final state = ProductState(); (X)
abstract class QuotesState extends Equatable {
  @override
  List<Object> get props => [];
}

class QuotesInitialState extends QuotesState {}

class QuotesLoadingState extends QuotesState {
  final bool isInitialLoad;
  QuotesLoadingState({this.isInitialLoad = false});
}

class SavedQuotesLoadingState extends QuotesState {
  SavedQuotesLoadingState();
}

class QuotesLoadedState extends QuotesState {
  final List<QuotesModel> quotes;
  QuotesLoadedState(this.quotes);

  @override
  List<Object> get props => [quotes];
}

class SavedQuotesLoadedState extends QuotesState {
  final List<QuotesModel> quotes;
  SavedQuotesLoadedState(this.quotes);

  @override
  List<Object> get props => [quotes];
}

class QuotesFailureState extends QuotesState {
  final String errorMessage;
  QuotesFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class SavedQuotesFailureState extends QuotesState {
  final String errorMessage;
  SavedQuotesFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

//QUOTE SAVED STATES
class SavedQuotesSucessState extends QuotesState {}

class SavedQuotesRemovedState extends QuotesState {}

class QuotesAlreadySavedState extends QuotesState {}
