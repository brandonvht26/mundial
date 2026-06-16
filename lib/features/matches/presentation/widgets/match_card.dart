import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/match.dart';
import '../widgets/team_badge.dart';

class MatchCard extends StatefulWidget {
  final Match match;
  final VoidCallback onTap;

  const MatchCard({
    super.key,
    required this.match,
    required this.onTap,
  });

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Usamos AnimatedScale para el efecto de "resorte" al presionar
    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
      child: Card(
        // CardTheme en AppTheme se encarga del color y elevación
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: () {
            widget.onTap();
            setState(() => _isPressed = false);
          },
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
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.match.phase,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.darkHeatherGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.match.status.isLive)
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
        else if (widget.match.status.isFinished)
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              TeamBadge(
                imageUrl: widget.match.homeTeam.logoUrl,
                size: 56,
                tag: 'team_home_${widget.match.id}',
              ),
              const SizedBox(height: 12),
              Text(
                widget.match.homeTeam.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.hermesBlue,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: Hero(
            tag: 'score_${widget.match.id}',
            child: Material(
            color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: AppTheme.secondaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.torchRed.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  widget.match.scoreDisplay,
                  style: const TextStyle(
                    fontSize: 22,
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
                imageUrl: widget.match.awayTeam.logoUrl,
                size: 56,
                tag: 'team_away_${widget.match.id}',
              ),
              const SizedBox(height: 12),
              Text(
                widget.match.awayTeam.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.hermesBlue,
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
    final ecuadorTime = widget.match.dateTime.toUtc().subtract(const Duration(hours: 5));
    final time = DateFormat('HH:mm').format(ecuadorTime);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.stadium, size: 14, color: AppTheme.darkHeatherGrey),
        const SizedBox(width: 4),
        Text(
          widget.match.stadium ?? '',
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
