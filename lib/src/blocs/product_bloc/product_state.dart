import 'package:ecom_app_bloc/src/models/product_model.dart';
import 'package:equatable/equatable.dart';

// The abstract keyword in Dart means you cannot create an instance of this class directly.
// It is meant to be extended or implemented by other classes, not used on its own.
// e.g. --> final state = ProductState(); (X)

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

//
class ProductInitialState extends ProductState {
  const ProductInitialState();
}

//
class ProductLoadingState extends ProductState {
  final bool isInitialLoad;

  const ProductLoadingState({this.isInitialLoad = false});
}

//
class ProductLoadedState extends ProductState {
  final List<ProductModel> products;

  const ProductLoadedState(this.products);

  @override
  List<Object> get props => [products];
}

//
class ProductFailureState extends ProductState {
  final String errorMessage;

  const ProductFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
