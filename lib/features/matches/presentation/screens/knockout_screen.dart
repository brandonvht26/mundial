import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/service_locator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/match.dart';
import '../widgets/match_card.dart';
import 'match_detail_screen.dart';

class KnockoutScreen extends StatefulWidget {
  const KnockoutScreen({super.key});

  @override
  State<KnockoutScreen> createState() => _KnockoutScreenState();
}

class _KnockoutScreenState extends State<KnockoutScreen> {
  late Stream<List<Match>> _matchesStream;

  @override
  void initState() {
    super.initState();
    _matchesStream = ServiceLocator.getAllMatches().asBroadcastStream();
  }

  Future<void> _refresh() async {
    setState(() {
      _matchesStream = ServiceLocator.getAllMatches(forceRefresh: true).asBroadcastStream();
    });
    try {
      await _matchesStream.first;
    } catch (_) {}
  }

  String _getPhaseTitle(String phase) {
    return phase;
  }

  Map<String, List<Match>> _groupMatchesByPhase(List<Match> matches) {
    final Map<String, List<Match>> grouped = {
      'Dieciseisavos de Final': [],
      'Octavos de Final': [],
      'Cuartos de Final': [],
      'Semifinal': [],
      'Tercer Lugar': [],
      'Gran Final': [],
    };

    for (final match in matches) {
      if (grouped.containsKey(match.phase)) {
        grouped[match.phase]!.add(match);
      }
    }
    return grouped;
  }

  Widget _buildPhaseSection(String phase, List<Match> phaseMatches) {
    if (phaseMatches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.torchRed,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _getPhaseTitle(phase),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.torchRed,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220, // Altura ajustada para evitar overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: phaseMatches.length,
            itemBuilder: (context, index) {
              final match = phaseMatches[index];
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: MatchCard(
                  match: match,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MatchDetailScreen(matchId: match.id),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Eliminatorias', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.secondaryGradient,
          ),
        ),
      ),
      body: StreamBuilder<List<Match>>(
        stream: _matchesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.torchRed));
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              color: AppTheme.torchRed,
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Center(
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
                ],
              ),
            );
          }

          final matches = snapshot.data ?? [];
          final groupedMatches = _groupMatchesByPhase(matches);

          final phasesOrder = [
            'Dieciseisavos de Final',
            'Octavos de Final',
            'Cuartos de Final',
            'Semifinal',
            'Tercer Lugar',
            'Gran Final',
          ];

          return RefreshIndicator(
            color: AppTheme.torchRed,
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: phasesOrder.length,
              itemBuilder: (context, index) {
                final phase = phasesOrder[index];
                return _buildPhaseSection(phase, groupedMatches[phase]!)
                    .animate()
                    .fade(duration: 400.ms, delay: (index * 100).ms)
                    .slideX(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad);
              },
            ),
          );
        },
      ),
    );
  }
}
