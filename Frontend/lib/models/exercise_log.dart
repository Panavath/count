class ExerciseLog {
  final int id;
  final int userId;
  final int exerciseId;
  final double durationMinutes;
  final DateTime date;

  ExerciseLog({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.durationMinutes,
    required this.date,
  });
}