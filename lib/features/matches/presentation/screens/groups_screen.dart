import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/service_locator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/match.dart';
import '../../domain/entities/match_status.dart';
import '../../domain/entities/team.dart';

class TeamStats {
  final Team team;
  int points = 0;
  int matchesPlayed = 0;
  int goalsFor = 0;
  int goalsAgainst = 0;

  int get goalDifference => goalsFor - goalsAgainst;

  TeamStats(this.team);
}

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
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

  Map<String, List<TeamStats>> _calculateStandings(List<Match> matches) {
    final Map<String, Map<String, TeamStats>> groupsData = {};

    for (final match in matches) {
      if (match.group == null || !match.phase.startsWith('Fase de Grupo')) continue;

      final groupId = match.group!.replaceAll('Grupo ', '').replaceAll('Group ', '');
      groupsData.putIfAbsent(groupId, () => {});

      final groupTeams = groupsData[groupId]!;
      
      final homeTeamName = match.homeTeam.name;
      final awayTeamName = match.awayTeam.name;
      
      groupTeams.putIfAbsent(homeTeamName, () => TeamStats(match.homeTeam));
      groupTeams.putIfAbsent(awayTeamName, () => TeamStats(match.awayTeam));

      if (match.status == MatchStatus.finished && match.homeScore != null && match.awayScore != null) {
        final homeStats = groupTeams[homeTeamName]!;
        final awayStats = groupTeams[awayTeamName]!;

        homeStats.matchesPlayed++;
        awayStats.matchesPlayed++;

        homeStats.goalsFor += match.homeScore!;
        homeStats.goalsAgainst += match.awayScore!;

        awayStats.goalsFor += match.awayScore!;
        awayStats.goalsAgainst += match.homeScore!;

        if (match.homeScore! > match.awayScore!) {
          homeStats.points += 3;
        } else if (match.homeScore! < match.awayScore!) {
          awayStats.points += 3;
        } else {
          homeStats.points += 1;
          awayStats.points += 1;
        }
      }
    }

    final Map<String, List<TeamStats>> finalStandings = {};
    
    final sortedGroupKeys = groupsData.keys.toList()..sort();
    
    for (final key in sortedGroupKeys) {
      final teamList = groupsData[key]!.values.toList();
      teamList.sort((a, b) {
        if (b.points != a.points) return b.points.compareTo(a.points);
        if (b.goalDifference != a.goalDifference) return b.goalDifference.compareTo(a.goalDifference);
        return b.goalsFor.compareTo(a.goalsFor);
      });
      finalStandings[key] = teamList;
    }

    return finalStandings;
  }

  Color _getRowColor(int index) {
    if (index == 0 || index == 1) return AppTheme.averageGreen.withValues(alpha: 0.15);
    if (index == 2) return AppTheme.hermesBlue.withValues(alpha: 0.15);
    return AppTheme.torchRed.withValues(alpha: 0.15);
  }
  
  Gradient _getIndicatorGradient(int index) {
    if (index == 0 || index == 1) {
      return const LinearGradient(
        colors: [AppTheme.averageGreen, Color(0xFF227821)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    if (index == 2) {
      return const LinearGradient(
        colors: [AppTheme.hermesBlue, Color(0xFF1A235A)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    return const LinearGradient(
      colors: [AppTheme.torchRed, Color(0xFFA11018)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  Widget _buildGroupTable(String groupName, List<TeamStats> teams) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2), // Grosor del borde dorado
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: const BoxDecoration(
                gradient: AppTheme.tertiaryGradient,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Text(
                'Grupo $groupName',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(20),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1),
                  5: FlexColumnWidth(1),
                },
                children: [
                  const TableRow(
                    children: [
                      SizedBox(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('Equipo', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.darkHeatherGrey)),
                      ),
                      Center(child: Text('PJ', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.darkHeatherGrey))),
                      Center(child: Text('GF', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.darkHeatherGrey))),
                      Center(child: Text('DIF', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.darkHeatherGrey))),
                      Center(child: Text('PTS', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.darkHeatherGrey))),
                    ],
                  ),
                  for (int i = 0; i < teams.length; i++)
                    TableRow(
                      decoration: BoxDecoration(
                        color: _getRowColor(i),
                        border: Border(bottom: BorderSide(color: AppTheme.lightGray.withValues(alpha: 0.3))),
                      ),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: _getIndicatorGradient(i),
                          ),
                          height: 48,
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Row(
                          children: [
                            Text('${i + 1}. ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Expanded(
                              child: Text(
                                teams[i].team.name,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(teams[i].matchesPlayed.toString()))),
                      Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(teams[i].goalsFor.toString()))),
                      Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(teams[i].goalDifference.toString()))),
                      Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(teams[i].points.toString(), style: const TextStyle(fontWeight: FontWeight.bold)))),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Grupos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.tertiaryGradient,
          ),
        ),
      ),
      body: StreamBuilder<List<Match>>(
        stream: _matchesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.averageGreen));
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              color: AppTheme.averageGreen,
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
          final standings = _calculateStandings(matches);

          if (standings.isEmpty) {
            return const Center(
              child: Text(
                'No hay información de grupos',
                style: TextStyle(color: AppTheme.darkHeatherGrey, fontSize: 16),
              ),
            );
          }

          final groupKeys = standings.keys.toList();

          return RefreshIndicator(
            color: AppTheme.averageGreen,
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: groupKeys.length,
              itemBuilder: (context, index) {
                final key = groupKeys[index];
                return _buildGroupTable(key, standings[key]!)
                    .animate()
                    .fade(duration: 400.ms, delay: (index * 50).ms)
                    .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad);
              },
            ),
          );
        },
      ),
    );
  }
}
