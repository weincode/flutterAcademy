import 'package:flutter/cupertino.dart';

enum DownloadStatus {
  notDownloaded,
  fetchingDownload,
  downloading,
  downloaded,
}

@immutable
class DownloadButton extends StatefulWidget {
  final DownloadStatus status;
  final Duration transitionDuration;

  const DownloadButton({
    Key? key,
    required this.status,
    this.transitionDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  @override
  Widget build(BuildContext context) {
    // TODO:
    return SizedBox();
  }
}
