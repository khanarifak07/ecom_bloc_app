import 'package:ecom_app_bloc/src/blocs/product_bloc/product_bloc.dart';
import 'package:ecom_app_bloc/src/screens/home/home.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => ProductBloc(), child: HomePage());
  }
}
