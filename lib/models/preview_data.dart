class PreviewData {
  final String claudicationTime;
  final String walkToRest;
  final String walkNoRest;
  final String timeAtRest;
  final String actualWalking;
  final int totalSteps;

  PreviewData({
    required this.claudicationTime,
    required this.walkToRest,
    required this.walkNoRest,
    required this.timeAtRest,
    required this.actualWalking,
    required this.totalSteps,
  });

  factory PreviewData.fromJson(Map<String, dynamic> json) {
    return PreviewData(
      claudicationTime: _formatTime(json['claudication_time']),
      walkToRest: _formatTime(json['walk_to_rest']),
      walkNoRest: _formatTime(json['walk_no_rest']),
      timeAtRest: _formatTime(json['time_at_rest']),
      actualWalking: _formatTime(json['actual_walking']),
      totalSteps: json['total_steps'],
    );
  }

  static String _formatTime(String timeString) {
    final timeParts = timeString.split(' ');
    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    for (int i = 0; i < timeParts.length; i += 2) {
      int value = int.parse(timeParts[i]);
      String unit = timeParts[i + 1];

      if (unit.startsWith('hour')) {
        hours = value;
      } else if (unit.startsWith('minute')) {
        minutes = value;
      } else if (unit.startsWith('second')) {
        seconds = value;
      }
    }

    String formattedTime = '';
    if (hours > 0) {
      formattedTime += '${hours}hours\n';
    }
    if (minutes > 0) {
      formattedTime += '${minutes}min\n';
    }
    if (seconds > 0) {
      formattedTime += '${seconds}sec';
    }

    return formattedTime;
  }
}
