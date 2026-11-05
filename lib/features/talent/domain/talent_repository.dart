class Talent {
  const Talent({
    required this.id,
    required this.name,
    required this.fullName,
    required this.specialty,
    required this.category,
    required this.rating,
    required this.rate,
    required this.completed,
    required this.skills,
    required this.initials,
    this.photoSlot = 'imgEditorialRealPhotography',
    this.projectPrice = 12500000,
    this.reviews = 12,
  });
  final String id,
      name,
      fullName,
      specialty,
      category,
      rating,
      photoSlot,
      initials;
  final int rate, completed, projectPrice, reviews;
  final List<String> skills;
}

abstract interface class TalentRepository {
  Future<List<Talent>> fetchTalent();
  Future<void> invite(String viewer, Set<String> ids);
}
