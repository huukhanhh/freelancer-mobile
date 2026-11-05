class Job {
  const Job({
    required this.id,
    required this.title,
    required this.client,
    required this.budget,
    required this.skills,
    required this.category,
    required this.days,
    required this.imageNode,
    required this.imageSlot,
    required this.createdAt,
    this.remote = true,
    this.verified = true,
    this.hourly = false,
  });
  final String id, title, client, category, imageNode, imageSlot;
  final int budget, days, createdAt;
  final List<String> skills;
  final bool remote, verified, hourly;
}

abstract interface class JobRepository {
  Future<List<Job>> fetchJobs();
}

class JobFilters {
  const JobFilters({
    this.category = '',
    this.technology = '',
    this.minimum = 0,
    this.maximum = 50000000,
    this.remote = false,
    this.verified = false,
    this.billing = '',
  });
  final String category, technology, billing;
  final int minimum, maximum;
  final bool remote, verified;
  JobFilters copyWith({
    String? category,
    String? technology,
    int? minimum,
    int? maximum,
    bool? remote,
    bool? verified,
    String? billing,
  }) => JobFilters(
    category: category ?? this.category,
    technology: technology ?? this.technology,
    minimum: minimum ?? this.minimum,
    maximum: maximum ?? this.maximum,
    remote: remote ?? this.remote,
    verified: verified ?? this.verified,
    billing: billing ?? this.billing,
  );
  bool matches(Job job) =>
      job.budget >= minimum &&
      job.budget <= maximum &&
      (!remote || job.remote) &&
      (!verified || job.verified) &&
      (category.isEmpty || job.category == category) &&
      (technology.isEmpty || job.skills.contains(technology)) &&
      (billing.isEmpty || (billing == 'Theo giờ') == job.hourly);
}

String jobMoney(int value) {
  final digits = value.toString();
  final out = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) out.write('.');
    out.write(digits[i]);
  }
  return '$out₫';
}
