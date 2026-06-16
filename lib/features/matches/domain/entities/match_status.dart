enum MatchStatus {
  scheduled,
  live,
  finished,
  unknown;

  bool get isLive => this == MatchStatus.live;
  bool get isFinished => this == MatchStatus.finished;
  bool get isScheduled => this == MatchStatus.scheduled;
}
