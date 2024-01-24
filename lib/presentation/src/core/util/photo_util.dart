import 'dart:developer';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get_it/get_it.dart';
import 'package:gogo_mvp_domain/usecase/image/download_image_usecase.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PhotoUtilException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  PhotoUtilException(this.message) : stackTrace = StackTrace.current;

  @override
  String toString() => "PhotoUtilException: $message";
}

class PhotoUtil {
  static Future<String?> pickImageFromGalleryAndCompressImage({
    int minSize = 1200,
    int compressQuality = 50,
    CompressFormat format = CompressFormat.heic,
  }) async {
    final originalImagePath = await _pickImageFromGallery();
    if (originalImagePath == null) return null;

    final compressedImagePath = await _compressAndTempSaveImage(
      originalImagePath,
      minSize: minSize,
      compressQuality: compressQuality,
      format: format,
    );
    if (compressedImagePath == null) {
      throw PhotoUtilException("이미지 압축에 실패하였습니다.");
    }

    return compressedImagePath;
  }

  /// if null, compress is failed.
  static Future<String?> _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    return pickedImage?.path;
  }

  /// if null, compress is failed.
  static Future<String?> _compressAndTempSaveImage(
    String originalImagePath, {
    required int minSize,
    required int compressQuality,
    required CompressFormat format,
  }) async {
    final tempPath = await getTemporaryDirectory().then((dir) => dir.path);
    final nowTime = DateTime.now().millisecondsSinceEpoch;
    final savePath = "$tempPath/$nowTime.${format.name}";

    FlutterImageCompress.showNativeLog = true;
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      originalImagePath,
      savePath,
      quality: compressQuality,
      format: format,
      minHeight: minSize,
      minWidth: minSize,
    );
    if (compressedImage == null) return null;
    final compressedImagePath = compressedImage.path;

    final originalImageSize = _getImageSizeInMb(originalImagePath);
    final compressedImageSize = _getImageSizeInMb(compressedImagePath);

    log("original: ${originalImageSize}MB, compressed: ${compressedImageSize}MB",
        name: "ImageCompressingSize");

    if (originalImageSize <= compressedImageSize) return originalImagePath;
    return compressedImagePath;
  }

  static bool isLocalPath(String path) => !isRemoteUrl(path);

  static bool isRemoteUrl(String url) => url.startsWith("http");

  static Future<void> downloadAndSaveImage(String url,
      {required String fileName}) async {
    final downloadAndSaveImage = GetIt.I.get<DownloadImageUseCase>();
    final bytes = await downloadAndSaveImage(remoteUrl: url);
    await ImageGallerySaver.saveImage(bytes, name: fileName, quality: 100);
  }

  /// return image size in MB
  static double _getImageSizeInMb(String path) {
    return File(path).lengthSync() / 1024 / 1024;
  }

  PhotoUtil._();
}
