import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../core/service_locator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/match.dart';
import '../widgets/team_badge.dart';

class MatchDetailScreen extends StatelessWidget {
  final int matchId;

  const MatchDetailScreen({super.key, required this.matchId});

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
        appBar: AppBar(
          title: const Text('Detalle del Partido', style: TextStyle(fontWeight: FontWeight.bold)),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
          ),
        ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder<Match>(
          future: ServiceLocator.getMatchDetail(matchId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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
                        style: const TextStyle(color: AppTheme.darkHeatherGrey),
                      ),
                    ],
                  ),
                ),
              );
            }

            final match = snapshot.data!;
            return _buildDetail(context, match);
          },
        ),
      ),
      ),
    );
  }

  Widget _buildDetail(BuildContext context, Match match) {
    final ecuadorTime = match.dateTime.toUtc().subtract(const Duration(hours: 5));
    final localTime = DateFormat('dd MMM yyyy - HH:mm', 'es')
        .format(ecuadorTime);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.hermesBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              match.phase,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (match.group != null) ...[
            const SizedBox(height: 8),
            Text(
              match.group!,
              style: const TextStyle(color: AppTheme.darkHeatherGrey, fontSize: 15, fontWeight: FontWeight.w600),
            ).animate().fade().slideY(begin: -0.2),
          ],
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    TeamBadge(
                      imageUrl: match.homeTeam.logoUrl,
                      size: 80,
                      tag: 'team_home_${match.id}',
                    ),
                    const SizedBox(height: 12),
                    Text(
                      match.homeTeam.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (match.homeScorers.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...match.homeScorers.map((scorer) => Text(
                        scorer,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: AppTheme.darkHeatherGrey),
                      )),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Hero(
                  tag: 'score_${match.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.secondaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.torchRed.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      match.scoreDisplay,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              ),
              Expanded(
                child: Column(
                  children: [
                    TeamBadge(
                      imageUrl: match.awayTeam.logoUrl,
                      size: 80,
                      tag: 'team_away_${match.id}',
                    ),
                    const SizedBox(height: 12),
                    Text(
                      match.awayTeam.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (match.awayScorers.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...match.awayScorers.map((scorer) => Text(
                        scorer,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: AppTheme.darkHeatherGrey),
                      )),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _infoCard(Icons.stadium, 'Estadio', match.stadium ?? 'Por definir', 0),
          if (match.stadiumCapacity != null)
            _infoCard(Icons.people, 'Capacidad', '${NumberFormat.decimalPattern('es').format(match.stadiumCapacity)} espectadores', 1),
          _infoCard(Icons.access_time, 'Fecha y hora (local)', localTime, 2),
          _infoCard(Icons.emoji_events, 'Fase', match.phase, 3),
          if (match.group != null)
            _infoCard(Icons.grid_view, 'Grupo', match.group!, 4),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value, int delayIndex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.averageGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.averageGreen, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.darkHeatherGrey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    ).animate().fade(duration: 400.ms, delay: (200 + delayIndex * 100).ms).slideX(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutQuad);
  }
}
