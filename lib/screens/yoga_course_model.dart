class YogaCourse {
  final String courseName;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;

  YogaCourse({
    required this.courseName,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
  });

  // Convert Firestore data into a YogaCourse object
  factory YogaCourse.fromFirestore(Map<String, dynamic> data) {
    return YogaCourse(
      courseName: data['courseName'],
      description: data['description'],
      videoUrl: data['videoUrl'],
      thumbnailUrl: data['thumbnailUrl'],
    );
  }
}
