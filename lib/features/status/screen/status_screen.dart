import 'package:clone_whatsapp/common/widgets/loader.dart';
import 'package:clone_whatsapp/models/status_model.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status-screen';

  final Status status;

  const StatusScreen({
    super.key,
    required this.status,
  });

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  late final StoryController _storyController;
  final List<StoryItem> _storyItems = [];

  @override
  void initState() {
    _storyController = StoryController();
    _initStoryPageItems();
    super.initState();
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  void _initStoryPageItems() {
    for (String photoUrl in widget.status.photoUrl) {
      _storyItems.add(StoryItem.pageImage(
        url: photoUrl,
        controller: _storyController,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _storyItems.isEmpty
          ? const Loader()
          : SafeArea(
        child: StoryView(
                storyItems: _storyItems,
                controller: _storyController,
                inline: false,
                repeat: false,
                onVerticalSwipeComplete: (direction) {
                  if (direction == Direction.down) {
                    Navigator.of(context).pop();
                  }
                },
              ),
          ),
    );
  }
}
