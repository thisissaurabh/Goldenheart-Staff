class CalltSession {
  final int id;
  final int astrologerId;
  final String chatStatus;
  final int deduction;
  final String totalMin;
  final String? chatRate; // Nullable field
  final String chatDuration;
  final String astroName;
  final String username;
  final String minuteDuration;
  final int callType;
  CalltSession({
    required this.id,
    required this.astrologerId,
    required this.chatStatus,
    required this.deduction,
    required this.totalMin,
    this.chatRate, // Nullable
    required this.chatDuration,
    required this.astroName,
    required this.username,
    required this.minuteDuration,
    required this.callType,
  });

  factory CalltSession.fromJson(Map<String, dynamic> json) {
    return CalltSession(
      id: json['id'] ?? 0,
      astrologerId: json['astrologerId'] ?? 0,
      chatStatus: json['callStatus'] ?? 'Unknown',
      deduction: json['deduction'] ?? 0,
      totalMin: json['totalMin'] ?? '0',
      chatRate: json['callRate'] != null
          ? json['callRate'].toString()
          : null, // Safe null handling
      chatDuration: json['call_duration'] ?? '0',
      astroName: json['astroname'] ?? '0',
      username: json['username'] ?? '0',
      minuteDuration: json['minute_duration'] ?? '0',
      callType: json['call_type'] ?? 0,
    );
  }
}
