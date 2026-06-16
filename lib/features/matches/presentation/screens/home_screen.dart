import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import 'groups_screen.dart';
import 'knockout_screen.dart';
import 'matches_calendar_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Índice 1 corresponde a MatchesCalendarView (Calendario)
  int _currentIndex = 1;

  final List<Widget> _screens = const [
    GroupsScreen(),
    MatchesCalendarView(),
    KnockoutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/wallpaper.png'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppTheme.lightGray.withValues(alpha: 0.3))),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: Colors.white,
              elevation: 0,
              selectedItemColor: AppTheme.hermesBlue,
              unselectedItemColor: AppTheme.darkHeatherGrey,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.table_chart_outlined),
                  activeIcon: Icon(Icons.table_chart),
                  label: 'Grupos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined),
                  activeIcon: Icon(Icons.calendar_today),
                  label: 'Calendario',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.emoji_events_outlined),
                  activeIcon: Icon(Icons.emoji_events),
                  label: 'Eliminación',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
