import 'package:clone_whatsapp/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/common/utils/colors.dart';

import 'package:clone_whatsapp/features/chat/screens/chat_screen.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  static const String routeName = '/mobile-layout-screen';

  const MobileLayoutScreen({super.key});

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver {
  late final PageController _pageController;
  int _currentIndex = 3;

  @override
  void initState() {
    _pageController = PageController(initialPage: _currentIndex);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(isOnline: true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        ref.read(authControllerProvider).setUserState(isOnline: false);
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void jumpToPage(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: _onPageChanged,
          children: const [
            Center(
              child: Text('Status'),
            ),
            Center(
              child: Text('Calls'),
            ),
            Center(
              child: Text('Camera'),
            ),
            ChatScreen(),
            Center(
              child: Text('Settings'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          jumpToPage(index);
        },
        backgroundColor: backgroundColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_outlined),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
