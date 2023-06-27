import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerItem({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late final CachedVideoPlayerController _videoPlayerController;
  bool _isPlaying = false;

  @override
  void initState() {
    _videoPlayerController = CachedVideoPlayerController.network(
      widget.videoUrl,
    )
      ..addListener(() {})
      ..initialize().then((_) {
        setState(() {});
        return _videoPlayerController.setVolume(1);
      });

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _playPauseVideo() {
    if (_isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }

    setState(() {
      _isPlaying = _videoPlayerController.value.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _videoPlayerController.value.aspectRatio,
      child: Stack(
        children: [
          CachedVideoPlayer(
            _videoPlayerController,
          ),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () => _playPauseVideo(),
              icon: Icon(
                _isPlaying ? Icons.pause_circle : Icons.play_circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
