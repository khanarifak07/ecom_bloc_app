import 'dart:convert';
import 'dart:developer';

import 'package:ecom_app_bloc/src/blocs/product_bloc/product_event.dart';
import 'package:ecom_app_bloc/src/blocs/product_bloc/product_state.dart';
import 'package:ecom_app_bloc/src/models/product_model.dart';
import 'package:ecom_app_bloc/src/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitialState()) {
    on<GetAllProductsEvent>(_getAllProductsEvent);
  }

  List<ProductModel> productsData = [];
  int currentOffset = 0;
  int pageSize = 10;
  bool hasMore = true;
  bool isLoading = false;

  //
  Future<void> _getAllProductsEvent(
    GetAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    if (!hasMore || isLoading) return;

    try {
      log('API CALLED');
      isLoading = true;
      // Only emit loading state if it's the very first fetch
      if (productsData.isEmpty) {
        emit(ProductLoadingState(isInitialLoad: true));
      } else {
        emit(ProductLoadingState(isInitialLoad: false)); // optional
      }

      final response = await http.get(
        Uri.parse(ApiService.getAllProductsWithPagination(currentOffset)),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final productList = data['products'] as List;
        final products = productList
            .map((e) => ProductModel.fromJson(e))
            .toList();

        if (products.length < pageSize) {
          hasMore = false;
        }

        productsData.addAll(products);
        currentOffset += pageSize;

        emit(ProductLoadedState(productsData));
      } else {
        emit(ProductFailureState('Error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ProductFailureState('Exception: $e'));
    } finally {
      isLoading = false;
    }
  }
}
