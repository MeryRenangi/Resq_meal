class DashboardActivityModel {
  const DashboardActivityModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.status,
  });

  final String id;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final String? status;

  factory DashboardActivityModel.fromMap(Map<String, dynamic> map) {
    return DashboardActivityModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      timestamp: DateTime.tryParse(map['timestamp']?.toString() ?? '') ?? DateTime.now(),
      status: map['status'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'timestamp': timestamp.toIso8601String(),
        if (status != null) 'status': status,
      };
}
