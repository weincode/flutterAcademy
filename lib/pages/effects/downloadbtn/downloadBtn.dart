import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'helpers/download_btn_controller.dart';
import 'helpers/enums.dart';

@immutable
class ExampleCupertinoDownloadButton extends StatefulWidget {
  const ExampleCupertinoDownloadButton({Key? key}) : super(key: key);

  @override
  _ExampleCupertinoDownloadButtonState createState() =>
      _ExampleCupertinoDownloadButtonState();
}

class _ExampleCupertinoDownloadButtonState extends State<ExampleCupertinoDownloadButton> {
  late final DownloadController _downloadController;

  @override
  void initState() {
    super.initState();
    _downloadController = SimulatedDownloadController(
        onOpenDownload: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Open App '),
            ),
          );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apps')),
      body: Center(
        child: AnimatedBuilder(
          animation: _downloadController,
          builder: (context, child) {
            return DownloadButton(
              status: _downloadController.downloadStatus,
              downloadProgress: _downloadController.progress,
              onDownload: _downloadController.startDownload,
              onCancel: _downloadController.stopDownload,
              onOpen: _downloadController.openDownload,
            );
          },
        ),
      ),
    );
  }
}

@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    Key? key,
    required this.status,
    this.downloadProgress = 0.0,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.transitionDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  final DownloadStatus status;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;
  final Duration transitionDuration;

  bool get _isDownloading => status == DownloadStatus.downloading;

  bool get _isFetching => status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
        break;
      case DownloadStatus.fetchingDownload:
      // do nothing.
        break;
      case DownloadStatus.downloading:
        onCancel();
        break;
      case DownloadStatus.downloaded:
        onOpen();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: [
          _buildButtonShape(
            child: _buildText(context),
          ),
          _buildDownloadingProgress(),
        ],
      ),
    );
  }
  Widget _buildButtonShape({required Widget child}) {
    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: _isDownloading || _isFetching
          ? ShapeDecoration(
        shape: const CircleBorder(),
        color: Colors.white.withOpacity(0.0),
      )
          : const ShapeDecoration(
        shape: StadiumBorder(),
        color: CupertinoColors.lightBackgroundGray,
      ),
      child: child,
    );
  }
  Widget _buildText(BuildContext context) {
    final text = _isDownloaded ? 'OPEN' : 'GET';
    final opacity = _isDownloading || _isFetching ? 0.0 : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: AnimatedOpacity(
        duration: transitionDuration,
        opacity: opacity,
        curve: Curves.ease,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.button?.copyWith(
            fontWeight: FontWeight.bold,
            color: CupertinoColors.activeBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadingProgress() {
    return Positioned.fill(
      child: AnimatedOpacity(
        duration: transitionDuration,
        opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
        curve: Curves.ease,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildProgressIndicator(),
            if (_isDownloading)
              const Icon(
                Icons.stop,
                size: 14.0,
                color: CupertinoColors.activeBlue,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: downloadProgress),
        duration: const Duration(milliseconds: 200),
        builder: (context, progress, child) {
          return CircularProgressIndicator(
            backgroundColor: _isDownloading
                ? CupertinoColors.lightBackgroundGray
                : Colors.white.withOpacity(0.0),
            valueColor: AlwaysStoppedAnimation(_isFetching
                ? CupertinoColors.lightBackgroundGray
                : CupertinoColors.activeBlue),
            strokeWidth: 2.0,
            value: _isFetching ? null : progress,
          );
        },
      ),
    );
  }
}