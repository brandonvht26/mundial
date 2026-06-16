import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/match.dart';
import '../widgets/team_badge.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final VoidCallback onTap;

  const MatchCard({
    super.key,
    required this.match,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildTeamsRow(),
              const SizedBox(height: 12),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          match.phase,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.darkHeatherGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (match.status.isLive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.averageGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'EN VIVO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        else if (match.status.isFinished)
          const Text(
            'Finalizado',
            style: TextStyle(fontSize: 12, color: AppTheme.darkHeatherGrey),
          ),
      ],
    );
  }

  Widget _buildTeamsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Column(
            children: [
              TeamBadge(
                imageUrl: match.homeTeam.logoUrl,
                size: 48,
                tag: 'team_home_${match.id}',
              ),
              const SizedBox(height: 8),
              Text(
                match.homeTeam.shortName ?? match.homeTeam.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Hero(
          tag: 'score_${match.id}',
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.hermesBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                match.scoreDisplay,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
                size: 48,
                tag: 'team_away_${match.id}',
              ),
              const SizedBox(height: 8),
              Text(
                match.awayTeam.shortName ?? match.awayTeam.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    // Forzar siempre a la zona horaria de Ecuador (GMT-5) sin importar la configuración del dispositivo
    final ecuadorTime = match.dateTime.toUtc().subtract(const Duration(hours: 5));
    final time = DateFormat('HH:mm').format(ecuadorTime);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.stadium, size: 14, color: AppTheme.darkHeatherGrey),
        const SizedBox(width: 4),
        Text(
          match.stadium ?? '',
          style: const TextStyle(fontSize: 12, color: AppTheme.darkHeatherGrey),
        ),
        const SizedBox(width: 12),
        const Icon(Icons.access_time, size: 14, color: AppTheme.darkHeatherGrey),
        const SizedBox(width: 4),
        Text(
          time,
          style: const TextStyle(fontSize: 12, color: AppTheme.darkHeatherGrey),
        ),
      ],
    );
  }
}
