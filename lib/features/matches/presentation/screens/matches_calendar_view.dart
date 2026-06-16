import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../core/service_locator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/match.dart';
import '../widgets/match_card.dart';
import 'match_detail_screen.dart';

class MatchesCalendarView extends StatefulWidget {
  const MatchesCalendarView({super.key});

  @override
  State<MatchesCalendarView> createState() => _MatchesCalendarViewState();
}

class _MatchesCalendarViewState extends State<MatchesCalendarView> {
  late DateTime _selectedDate;
  late Stream<List<Match>> _matchesStream;

  static final _tournamentStart = DateTime(2026, 6, 11);
  static final _tournamentEnd = DateTime(2026, 7, 19);

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Fecha por defecto: Día actual
    _matchesStream = ServiceLocator.getMatchesByDate(_selectedDate).asBroadcastStream();
  }

  Future<void> _refreshMatches(DateTime date, {bool forceRefresh = false}) async {
    setState(() {
      _selectedDate = date;
      _matchesStream = ServiceLocator.getMatchesByDate(date, forceRefresh: forceRefresh).asBroadcastStream();
    });
    if (forceRefresh) {
      try {
        await _matchesStream.first;
      } catch (_) {}
    }
  }

  Future<void> _pickDate() async {
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

    return Scaffold(
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
              child: StreamBuilder<List<Match>>(
                stream: _matchesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return RefreshIndicator(
                      color: AppTheme.hermesBlue,
                      onRefresh: () => _refreshMatches(_selectedDate, forceRefresh: true),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline, color: AppTheme.torchRed, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                snapshot.error.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppTheme.darkHeatherGrey, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final matches = snapshot.data ?? [];

                  if (matches.isEmpty) {
                    return RefreshIndicator(
                      color: AppTheme.hermesBlue,
                      onRefresh: () => _refreshMatches(_selectedDate, forceRefresh: true),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(20),
                          child: const Text(
                            'No hay partidos del Mundial en esta fecha',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.darkHeatherGrey, fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppTheme.hermesBlue,
                    onRefresh: () => _refreshMatches(_selectedDate, forceRefresh: true),
                    child: ListView.builder(
                      itemCount: matches.length,
                      padding: const EdgeInsets.only(bottom: 20),
                      physics: const AlwaysScrollableScrollPhysics(),
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
