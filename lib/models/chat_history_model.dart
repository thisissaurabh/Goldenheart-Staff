class ChatSession {
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
  ChatSession({
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
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'] ?? 0,
      astrologerId: json['astrologerId'] ?? 0,
      chatStatus: json['chatStatus'] ?? 'Unknown',
      deduction: json['deduction'] ?? 0,
      totalMin: json['totalMin'] ?? '0',
      chatRate: json['chatRate'] != null ? json['chatRate'].toString() : null, // Safe null handling
      chatDuration: json['chat_duration'] ?? '0',
      astroName: json['astroname'] ?? 'Staff Member',
            username: json['username'] ?? 'User',
      minuteDuration: json['minute_duration'] ?? '0',
    );
  }
}
