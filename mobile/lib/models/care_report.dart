class CareReport {
  final String summary;
  final String severity;
  final String recommendedAction;

  const CareReport({
    required this.summary,
    required this.severity,
    required this.recommendedAction,
  });

  factory CareReport.fromJson(Map<String, dynamic> json) {
    return CareReport(
      summary: json['summary'] as String,
      severity: json['severity'] as String,
      recommendedAction: json['recommended_action'] as String,
    );
  }
}
