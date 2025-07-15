import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_bloc.dart';
import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_event.dart';
import 'package:ecom_app_bloc/src/constants/my_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClearAllQuotesDialog extends StatelessWidget {
  const ClearAllQuotesDialog({super.key, required this.parentContext});

  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Are you sure to clear all saved quotes ?',
            style: MyFont.laughingAndSmiling,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  parentContext.read<QuotesBloc>().add(
                    ClearAllSavedQuotesEvent(),
                  );
                  Navigator.pop(context);
                },
                child: Text('YES', style: TextStyle(color: Colors.green)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('NO', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
