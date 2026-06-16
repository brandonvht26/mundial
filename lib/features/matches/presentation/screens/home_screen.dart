import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../core/service_locator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/match.dart';
import '../widgets/match_card.dart';
import 'match_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _selectedDate;
  late Future<List<Match>> _matchesFuture;

  static final _tournamentStart = DateTime(2026, 6, 11);
  static final _tournamentEnd = DateTime(2026, 7, 19);

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Fecha por defecto: Día actual
    _matchesFuture = ServiceLocator.getMatchesByDate(_selectedDate);
  }

  void _refreshMatches(DateTime date) {
    setState(() {
      _selectedDate = date;
      _matchesFuture = ServiceLocator.getMatchesByDate(date);
    });
  }

  Future<void> _pickDate() async {
    // Si _selectedDate está fuera del rango del torneo, ajustamos la fecha inicial del DatePicker
    DateTime validInitialDate = _selectedDate;
    if (validInitialDate.isBefore(_tournamentStart)) {
      validInitialDate = _tournamentStart;
    } else if (validInitialDate.isAfter(_tournamentEnd)) {
      validInitialDate = _tournamentEnd;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: validInitialDate,
      firstDate: _tournamentStart,
      lastDate: _tournamentEnd,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.hermesBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      _refreshMatches(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM yyyy', 'es').format(_selectedDate);

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
        appBar: AppBar(
          title: const Text('FIFA Copa Mundial 2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
          ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _pickDate,
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              dateStr,
              style: const TextStyle(
                color: AppTheme.darkHeatherGrey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Match>>(
              future: _matchesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppTheme.torchRed,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppTheme.darkHeatherGrey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final matches = snapshot.data ?? [];

                if (matches.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No hay partidos del Mundial en esta fecha',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.darkHeatherGrey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: matches.length,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    return MatchCard(
                      match: match,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MatchDetailScreen(matchId: match.id),
                        ),
                      ),
                    ).animate()
                     .fade(duration: 400.ms, delay: (index * 100).ms)
                     .slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutQuad);
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
    ),
    );
  }
}
