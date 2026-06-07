import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class AppCachedNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final BorderRadiusGeometry? borderRadius;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
    this.borderRadius,
  });

  @override
  State<AppCachedNetworkImage> createState() => _AppCachedNetworkImageState();
}

class _AppCachedNetworkImageState extends State<AppCachedNetworkImage> {
  File? compressedFile;

  @override
  void initState() {
    super.initState();
    compressImage();
  }

  Future<void> compressImage() async {
    try {
      /// 🔥 Download image
      final response = await http.get(Uri.parse(widget.imageUrl));

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await file.writeAsBytes(response.bodyBytes);

      /// 🔥 Compress
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        '${dir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
        quality: 70, // 🔥 adjust (40–70 best)
      );

      if (result != null && mounted) {
        setState(() {
          compressedFile = File(result.path);
        });
      }
    } catch (e) {
      debugPrint("Compression error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
      child: compressedFile != null
          ? Image.file(
              compressedFile!,
              height: widget.height,
              width: widget.width,
              fit: widget.fit,
            )
          : Container(
              height: widget.height,
              width: widget.width,
              alignment: Alignment.center,
              child: const CupertinoActivityIndicator(),
            ),
    );
  }
}
