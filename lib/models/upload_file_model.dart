import 'package:flutter/foundation.dart';

enum UploadStatus { uploading, failed, success }

class UploadFileModel {
  UploadFileModel({
    required this.name,
    required this.extension,
    required this.sizeInBytes,
  })  : id = DateTime.now().microsecondsSinceEpoch.toString(),
        progress = ValueNotifier<double>(0),
        status = ValueNotifier<UploadStatus>(UploadStatus.uploading);

  final String id;
  final String name;
  final String extension;
  final int sizeInBytes;
  final ValueNotifier<double> progress;
  final ValueNotifier<UploadStatus> status;

  static const int maxSizeBytes = 10 * 1024 * 1024; // 10 MB

  static const List<String> allowedExtensions = [
    'pdf',
    'png',
    'jpg',
    'jpeg',
    'heic',
  ];

  String get formattedSize {
    if (sizeInBytes < 1024) return '${sizeInBytes}B';
    if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(0)}KB';
    }
    return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  /// Simulated total upload time in seconds based on file size (~2 MB/s).
  double get totalUploadSeconds {
    final raw = sizeInBytes / (2 * 1024 * 1024);
    return raw.clamp(2.0, 10.0);
  }

  String estimatedTimeLeft(double currentProgress) {
    if (currentProgress >= 1.0) return 'Done';
    final remaining = totalUploadSeconds * (1.0 - currentProgress);
    if (remaining > 60) {
      final minutes = (remaining / 60).ceil();
      return '$minutes minute${minutes > 1 ? 's' : ''} left';
    }
    final seconds = remaining.ceil();
    return '$seconds second${seconds != 1 ? 's' : ''} left';
  }

  void dispose() {
    progress.dispose();
    status.dispose();
  }
}
