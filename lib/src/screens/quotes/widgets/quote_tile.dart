// ignore_for_file: use_build_context_synchronously

import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_bloc.dart';
import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_event.dart';
import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_state.dart';
import 'package:ecom_app_bloc/src/constants/my_font.dart';
import 'package:ecom_app_bloc/src/models/quotes_model.dart';
import 'package:ecom_app_bloc/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

class QuoteTile extends StatelessWidget {
  const QuoteTile({super.key, required this.quote, this.index, this.globalKey});

  final int? index;
  final QuotesModel quote;
  final GlobalKey? globalKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: ExpansionTile(
        initiallyExpanded: true,
        showTrailingIcon: false,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        childrenPadding: const EdgeInsets.all(5),
        backgroundColor: Colors.green.shade100,
        collapsedBackgroundColor: Colors.green.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          quote.quote ?? '',
          style: MyFont.laughingAndSmiling.copyWith(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        subtitle: Align(
          alignment: Alignment.center,
          child: Text(
            '~ ${quote.author ?? 'Unknown'}',
            style: TextStyle(color: Colors.black),
          ),
        ),
        children: [
          BlocBuilder<QuotesBloc, QuotesState>(
            builder: (context, state) {
              final isSaved = Utils.isQuoteAlreadySaved(quote);
              final bloc = context.read<QuotesBloc>();

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<QuotesBloc>().add(
                        SaveQuoteToGalleryEvent(context, globalKey!),
                      );
                    },
                    icon: Icon(Icons.download, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {
                      isSaved
                          ? bloc.add(RemoveQuoteByIndexEvent(index!))
                          : bloc.add(SaveQuoteEvent([quote]));
                    },
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_outline,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      bloc.add(ShareQuoteEvent(globalKey!));
                    },
                    icon: Icon(Icons.share, color: Colors.black),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class QuoteEqualizerWidget extends StatefulWidget {
  final String quote;

  const QuoteEqualizerWidget({super.key, required this.quote});

  @override
  State<QuoteEqualizerWidget> createState() => _QuoteEqualizerWidgetState();
}

class _QuoteEqualizerWidgetState extends State<QuoteEqualizerWidget> {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  // late Timer _timer;
  List<double> barHeights = List.generate(10, (_) => 10);

  @override
  void dispose() {
    // _timer.cancel();
    flutterTts.stop();
    super.dispose();
  }

  // void _speakQuote() async {
  //   await flutterTts.setLanguage("en-US");
  //   await flutterTts.setPitch(1);
  //   await flutterTts.setSpeechRate(0.5);

  //   setState(() => isSpeaking = true);
  //   _startEqualizer();

  //   await flutterTts.speak(widget.quote);

  //   flutterTts.setCompletionHandler(() {
  //     setState(() => isSpeaking = false);
  //     _timer.cancel();
  //   });
  // }

  // void _startEqualizer() {
  //   _timer = Timer.periodic(const Duration(milliseconds: 150), (_) {
  //     setState(() {
  //       barHeights = List.generate(15, (_) => Random().nextDouble() * 40 + 10);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // IconButton(
        //   onPressed: isSpeaking ? null : _speakQuote,
        //   icon: Icon(Icons.play_circle_fill_outlined, color: Colors.black),
        // ),
        const SizedBox(height: 20),
        if (isSpeaking)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: barHeights
                .map(
                  (height) => EqualizerBar(height: height, color: Colors.green),
                )
                .toList(),
          ),
      ],
    );
  }
}

class EqualizerBar extends StatelessWidget {
  final double height;
  final Color color;

  const EqualizerBar({super.key, required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 5,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
