class LogEntryModel {
  final String timestamp;
  final String level;
  final String category;
  final String message;
  final int? userId;
  final Map<String, dynamic>? metadata;

  LogEntryModel({
    required this.timestamp,
    required this.level,
    required this.category,
    required this.message,
    this.userId,
    this.metadata,
  });

  factory LogEntryModel.fromJson(Map<String, dynamic> json) {
    // Remove known fields from metadata
    final Map<String, dynamic>? cleanMetadata =
        json.isNotEmpty ? Map<String, dynamic>.from(json) : null;

    cleanMetadata?.remove('timestamp');
    cleanMetadata?.remove('level');
    cleanMetadata?.remove('category');
    cleanMetadata?.remove('message');
    cleanMetadata?.remove('userId');

    return LogEntryModel(
      timestamp: json['timestamp'] ?? '',
      level: json['level'] ?? 'info',
      category: json['category'] ?? 'system',
      message: json['message'] ?? '',
      userId: json['userId'],
      metadata: cleanMetadata?.isNotEmpty == true ? cleanMetadata : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'level': level,
      'category': category,
      'message': message,
      if (userId != null) 'userId': userId,
      if (metadata != null) 'metadata': metadata,
    };
  }

  String get levelIcon {
    switch (level.toLowerCase()) {
      case 'error':
        return '❌';
      case 'warn':
      case 'warning':
        return '⚠️';
      case 'info':
        return 'ℹ️';
      case 'debug':
        return '🐛';
      default:
        return '📝';
    }
  }
}
