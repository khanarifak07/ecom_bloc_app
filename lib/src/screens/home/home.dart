import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_app_bloc/src/blocs/product_bloc/product_bloc.dart';
import 'package:ecom_app_bloc/src/blocs/product_bloc/product_event.dart';
import 'package:ecom_app_bloc/src/blocs/product_bloc/product_state.dart';
import 'package:ecom_app_bloc/src/screens/products/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetAllProductsEvent());
    _scrollController = ScrollController();
    _scrollController?.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController!.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      log('Reached Bottom');
      context.read<ProductBloc>().add(GetAllProductsEvent());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          final productBloc = context.read<ProductBloc>();

          if (state is ProductLoadingState && state.isInitialLoad) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductLoadedState ||
              (state is ProductLoadingState && !state.isInitialLoad)) {
            final products = productBloc.productsData;

            return GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length + (productBloc.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < products.length) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailsPage(productModel: product),
                      ),
                    ),
                    child: Card(
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            height: 120,
                            imageUrl: product.images![0],
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.medium,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Center(child: Icon(Icons.error)),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              product.title ?? 'NA',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Bottom loader
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            );
          }

          if (state is ProductFailureState) {
            return Center(child: Text(state.errorMessage));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
