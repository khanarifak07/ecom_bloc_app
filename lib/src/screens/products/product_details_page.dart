import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_app_bloc/src/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductModel productModel;
  const ProductDetailsPage({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController = CarouselController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: SizedBox(
              width: double.maxFinite,
              child: CarouselView(
                
                itemExtent: 500,
                itemSnapping: true,
                backgroundColor: Colors.grey.shade100,
                scrollDirection: Axis.horizontal,
                controller: carouselController,
                children: productModel.images!
                    .map(
                      (e) =>
                          CachedNetworkImage(imageUrl: e, fit: BoxFit.contain),
                    )
                    .toList(),
              ),
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(productModel.images!.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      // ignore: unrelated_type_equality_checks
                      color: carouselController == index
                          ? Colors.red
                          : Colors.amberAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 20,
                    width: 20,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
