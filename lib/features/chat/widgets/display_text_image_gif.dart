import 'package:cached_network_image/cached_network_image.dart';
import 'package:clone_whatsapp/common/enums/message_enum.dart';
import 'package:clone_whatsapp/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class DisplayTextImageGIF extends StatefulWidget {
  final MessageTypeEnum type;
  final String message;

  const DisplayTextImageGIF({
    super.key,
    required this.type,
    required this.message,
  });

  @override
  State<DisplayTextImageGIF> createState() => _DisplayTextImageGIFState();
}

class _DisplayTextImageGIFState extends State<DisplayTextImageGIF> {
  late final FlutterSoundPlayer _soundPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    if (widget.type == MessageTypeEnum.audio) {
      _initAudio();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.type == MessageTypeEnum.audio) {
      _soundPlayer.closePlayer();
    }
    super.dispose();
  }

  void _initAudio() async {
    _soundPlayer = FlutterSoundPlayer();
    await _soundPlayer.openPlayer();
  }

  void _playAudio({
    required bool isPlaying,
    required String url,
  }) async {
    try {
      if (isPlaying) {
        await _soundPlayer.stopPlayer();
        return;
      }

      await _soundPlayer.startPlayer(
        fromURI: url,
      );

      // TODO: add listener to stop player when audio is finished
    } catch (e) {
      await _soundPlayer.stopPlayer();

      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case MessageTypeEnum.audio:
        return _displayAudio(context);

      case MessageTypeEnum.image:
        return _displayImage(context);

      case MessageTypeEnum.gif:
        return _displayGIF(context);

      case MessageTypeEnum.video:
        return _displayVideo(context);

      case MessageTypeEnum.text:
      default:
        return _displayText(context);
    }
  }

  Widget _displayAudio(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return IconButton(
      constraints: BoxConstraints(
        minWidth: size.width * 0.3,
      ),
      onPressed: () {
        if (!_isPlaying) {
          _playAudio(
            isPlaying: _isPlaying,
            url: widget.message,
          );
        } else {
          _playAudio(
            isPlaying: _isPlaying,
            url: widget.message,
          );
        }

        setState(() {
          _isPlaying = !_isPlaying;
        });
      },
      icon: Icon(
        _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
      ),
    );
  }

  Widget _displayText(BuildContext context) {
    return Text(
      widget.message,
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }

  Widget _displayImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.message,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: BoxFit.cover,
    );
  }

  Widget _displayGIF(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.message,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: BoxFit.cover,
    );
  }

  Widget _displayVideo(BuildContext context) {
    return VideoPlayerItem(
      videoUrl: widget.message,
    );
  }
}
