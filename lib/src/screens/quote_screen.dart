// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';

// class QuoteScreen extends StatefulWidget {
//   const QuoteScreen({super.key});

//   @override
//   State<QuoteScreen> createState() => _QuoteScreenState();
// }

// class _QuoteScreenState extends State<QuoteScreen> {
//   final GlobalKey _quoteKey = GlobalKey();

//   Future<Uint8List?> _captureWidget() async {
//     try {
//       RenderRepaintBoundary boundary =
//           _quoteKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

//       if (boundary.debugNeedsPaint) {
//         await Future.delayed(const Duration(milliseconds: 20));
//         return _captureWidget();
//       }

//       final image = await boundary.toImage(pixelRatio: 3.0);
//       final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//       return byteData?.buffer.asUint8List();
//     } catch (e) {
//       debugPrint("Capture error: $e");
//       return null;
//     }
//   }

//   Future<void> _saveImage() async {
//     final permission = await Permission.storage.request();

//     if (!permission.isGranted) {
//       if (permission.isPermanentlyDenied) {
//         openAppSettings();
//         return;
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Storage permission is required.")),
//       );
//       return;
//     }

//     final imageBytes = await _captureWidget();

//     if (imageBytes != null) {
//       final result = await ImageGallerySaver.saveImage(imageBytes);
//       debugPrint("Image saved: $result");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Image saved to gallery.")));
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Failed to capture image.")));
//     }
//   }

//   Future<void> _shareImage() async {
//     try {
//       final imageBytes = await _captureWidget();
//       if (imageBytes == null) return;

//       final tempDir = await getTemporaryDirectory();
//       final filePath =
//           '${tempDir.path}/quote_${DateTime.now().millisecondsSinceEpoch}.png';
//       final file = await File(filePath).create();
//       await file.writeAsBytes(imageBytes);

//       final params = ShareParams(
//         text: 'Here is a quote I wanted to share.',
//         files: [XFile(file.path)],
//       );

//       final result = await SharePlus.instance.share(params);

//       if (result.status == ShareResultStatus.success) {
//         debugPrint("Image shared successfully.");
//       }
//     } catch (e) {
//       debugPrint("Share error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Quote Share'), centerTitle: true),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             RepaintBoundary(
//               key: _quoteKey,
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.teal.shade100,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.teal.shade200,
//                       blurRadius: 8,
//                       offset: const Offset(2, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       '"Believe you can and you\'re halfway there."',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontStyle: FontStyle.italic,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: Text(
//                         "- Theodore Roosevelt",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: _saveImage,
//                   icon: const Icon(Icons.download),
//                   label: const Text("Save"),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: _shareImage,
//                   icon: const Icon(Icons.share),
//                   label: const Text("Share"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
