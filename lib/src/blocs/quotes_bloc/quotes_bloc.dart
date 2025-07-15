// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_event.dart';
import 'package:ecom_app_bloc/src/blocs/quotes_bloc/quotes_state.dart';
import 'package:ecom_app_bloc/src/models/quotes_model.dart';
import 'package:ecom_app_bloc/src/services/api_service.dart';
import 'package:ecom_app_bloc/src/services/notification_service.dart';
import 'package:ecom_app_bloc/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class QuotesBloc extends Bloc<QuotesEvent, QuotesState> {
  QuotesBloc() : super(QuotesInitialState()) {
    on<GetAllQuotesEvent>(_getAllQuotesEvent);
    on<SaveQuoteEvent>(_saveQuotes);
    on<GetAllSavedQuotesEvent>(_loadSavedQuotes);
    on<ClearAllSavedQuotesEvent>(_clearSavedQuotes);
    on<RemoveQuoteByIndexEvent>(_removeQuoteAtIndex);
    on<GetQuotesByAuthorEvent>(_getQuotesByAuthor);
    on<ClearFilterEvent>(_clearFilter);
    on<SearchQuotesEvent>(_searchQuotes);
    on<GetRandomQuotesEvent>(_getRandomQuotes);
    on<SaveQuoteToGalleryEvent>(_saveQuoteToGallery);
    on<ShareQuoteEvent>(_shareQuotes);
  }

  QuotesModel? randomQuoteModel;
  List<QuotesModel> quotesData = [];
  List<GlobalKey> quotesKey = [];
  Set<String> authorNames = {};
  bool hasMore = true;
  int currentOffset = 0;
  int pageSize = 50;
  bool isLoading = false;
  bool isFilter = false;
  TextEditingController searchCtrl = TextEditingController();
  Timer? timer;
  Timer? debounce;

  @override
  Future<void> close() {
    timer?.cancel();
    debounce?.cancel();
    return super.close();
  }

  //
  Future<void> _getAllQuotesEvent(
    GetAllQuotesEvent event,
    Emitter<QuotesState> emit,
  ) async {
    try {
      if (isFilter || isLoading || !hasMore) return;

      isLoading = true;

      if (quotesData.isEmpty) {
        emit(QuotesLoadingState(isInitialLoad: true));
      } else {
        emit(QuotesLoadingState(isInitialLoad: false));
      }

      final response = await http.get(
        Uri.parse(ApiService.getAllQuotes(currentOffset)),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final dataList = result['quotes'] as List;

        //1
        var newAuthors = dataList
            .map((e) => e['author']?.toString().trim())
            .where((name) => name != null && name.isNotEmpty)
            .cast<String>();
        //
        authorNames.addAll(newAuthors);
        // log(authorNames.toString());
        //2
        // for (var data in dataList) {
        //   authorNames.add(data['author']);
        //   log(authorNames.toString());
        // }
        final quotes = dataList.map((e) => QuotesModel.fromJson(e)).toList();

        if (quotes.length < pageSize) {
          hasMore = false;
        }

        quotesData.addAll(quotes);
        currentOffset += pageSize;

        emit(QuotesLoadedState(quotesData));
      }
    } catch (e) {
      log('Error while getting all quotes $e');
      emit(QuotesFailureState("Error $e"));
    } finally {
      isLoading = false;
    }
  }

  //
  void _saveQuotes(SaveQuoteEvent event, Emitter<QuotesState> emit) async {
    try {
      // Step 1: Get existing saved quotes
      final existingQuotes = Utils.getQuotes() ?? [];

      // Step 2: Create a Set of existing IDs to check for duplicates
      final existingIds = existingQuotes.map((e) => e.id).toSet();

      // Step 3: Filter new quotes that are not already saved
      final newQuotes = event.quotes
          .where((e) => !existingIds.contains(e.id))
          .toList();

      // Step 4: Show appropriate state
      if (newQuotes.isNotEmpty) {
        final updatedList = [...existingQuotes, ...newQuotes];
        Utils.saveQoutes(updatedList);
        emit(SavedQuotesSucessState());
      } else {
        emit(QuotesAlreadySavedState());
      }
      emit(QuotesLoadedState(quotesData));
    } catch (e) {
      emit(SavedQuotesFailureState('Failed saving quotes $e'));
    }
  }

  //
  void _loadSavedQuotes(
    GetAllSavedQuotesEvent event,
    Emitter<QuotesState> emit,
  ) async {
    try {
      //get the quptes
      emit(SavedQuotesLoadingState());
      final savedQuotes = Utils.getQuotes() ?? [];
      emit(SavedQuotesLoadedState(savedQuotes));
    } catch (e) {
      emit(SavedQuotesFailureState('Error while loading saved quotes $e'));
    }
  }

  //
  void _clearSavedQuotes(
    ClearAllSavedQuotesEvent event,
    Emitter<QuotesState> emit,
  ) {
    Utils.clearSavedQuotes();
    //
    emit(QuotesInitialState());
    emit(QuotesLoadedState(quotesData));
  }

  //
  void _removeQuoteAtIndex(
    RemoveQuoteByIndexEvent event,
    Emitter<QuotesState> emit,
  ) {
    Utils.removeQuoteByIndex(event.index);
    emit(SavedQuotesRemovedState());
    final updatedQuotes = Utils.getQuotes() ?? [];
    emit(SavedQuotesLoadedState(updatedQuotes));
    emit(QuotesLoadedState(quotesData));
  }

  //
  void _getQuotesByAuthor(
    GetQuotesByAuthorEvent event,
    Emitter<QuotesState> emit,
  ) {
    try {
      final selectedAuthor = event.author;
      isFilter = true;
      List<QuotesModel> filteredQuotes = quotesData
          .where((e) => e.author?.trim() == selectedAuthor)
          .toList();

      // log(filteredQuotes.toString());
      emit(QuotesLoadedState(filteredQuotes));
    } catch (e) {
      log('Error while filtering quotes $e');
    }
  }

  //
  void _clearFilter(ClearFilterEvent event, Emitter<QuotesState> emit) {
    isFilter = false;
    emit(QuotesLoadedState(quotesData));
  }

  //
  void _searchQuotes(SearchQuotesEvent event, Emitter<QuotesState> emit) {
    //
    isFilter = true;
    //get the searchQuery
    String query = event.searchQuery.toLowerCase();
    final result = quotesData.where((quote) {
      final quoteText = quote.quote?.toLowerCase() ?? '';
      final authortext = quote.author?.toLowerCase() ?? '';
      return quoteText.contains(query) || authortext.contains(query);
    }).toList();
    //
    emit(QuotesLoadedState(result));
  }

  //random quotes
  void _getRandomQuotes(
    GetRandomQuotesEvent event,
    Emitter<QuotesState> emit,
  ) async {
    try {
      final response = await http.get(Uri.parse(ApiService.getRandomQuotes));
      // log(response.body.toString());
      if (response.statusCode == 200) {
        final randomQuote = response.body;
        var model = QuotesModel.fromJson(jsonDecode(randomQuote));
        // randomQuoteModel = data;
        await NotificationService().showNotification(model);
        NotificationService().shceduledNotification(
          model: model,
          hour: 13,
          minute: 39,
        );
      }
    } catch (e) {
      log('Error while getting random quotes $e');
    }
  }

  //capture quote as image
  Future<Uint8List?> _captureQuoteWidget(GlobalKey globalKey) async {
    try {
      //
      RenderRepaintBoundary boundry =
          globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      //
      if (boundry.debugNeedsPaint) {
        await Future.delayed(Duration(milliseconds: 20), () {
          return _captureQuoteWidget(globalKey);
        });
        //
        final image = await boundry.toImage(pixelRatio: 3.0);
        //
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        //
        return byteData?.buffer.asUint8List();
      }
    } catch (e) {
      log('Error while capturing widget $e');
    }
    return null;
  }

  //save to gallery
  void _saveQuoteToGallery(
    SaveQuoteToGalleryEvent event,
    Emitter<QuotesState> emit,
  ) async {
    try {
      //first check permissions
      // final permission = await Permission.phone.request();
      // if (!permission.isGranted) {
      //   if (permission.isPermanentlyDenied) {
      //     openAppSettings();
      //     return;
      //   }
      //   Utils.showFailureSnackbar(
      //     event.context,
      //     'Storage permission is required',
      //   );
      //   return;
      // }
      final Uint8List? image = await _captureQuoteWidget(event.globalKey);
      //
      if (image != null) {
        final result = await ImageGallerySaverPlus.saveImage(image);
        log('Image saved: $result');
        Utils.showSuccessSnackbar(event.context, 'Image saved to gallery');
      } else {
        Utils.showFailureSnackbar(event.context, 'Failed to save image');
      }
    } catch (e) {
      log('Error while saving to gallery $e');
    }
  }

  //share image
  void _shareQuotes(ShareQuoteEvent event, Emitter<QuotesState> emit) async {
    try {
      //get the image
      final image = await _captureQuoteWidget(event.globalKey);
      if (image == null) return;
      //
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}${DateTime.now().millisecondsSinceEpoch}.png';
      //
      final file = await File(filePath).create();
      await file.writeAsBytes(image);

      //share
      final params = ShareParams(
        text: 'Here is a quote I wanted to share',
        files: [XFile(file.path)],
      );
      //
      final result = await SharePlus.instance.share(params);
      if (result.status == ShareResultStatus.success) {
        debugPrint("Image shared successfully.");
      }
    } catch (e) {
      log('Error while sharing quotes $e');
    }
  }
}
