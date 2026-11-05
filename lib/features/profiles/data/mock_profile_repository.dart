import 'package:workly/features/profiles/domain/profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
  final _profiles = <String, FreelancerProfile>{};
  static const entries = [
    PortfolioEntry(
      id: 'may',
      title: 'Ứng dụng chi tiêu Mây',
      metadata: 'Fintech · Mobile App · 2026',
      node: '585:5527',
      slot: 'imgProjectImage',
    ),
    PortfolioEntry(
      id: 'health',
      title: 'Chăm sóc sức khỏe số',
      metadata: 'Healthcare · Product Design · 2025',
      node: '585:5527',
      slot: 'imgProjectImage1',
    ),
  ];
  @override
  Future<FreelancerProfile> fetchProfile(String viewer) async => _profiles
      .putIfAbsent(viewer, () => const FreelancerProfile(portfolio: entries));
  @override
  Future<void> saveProfile(String viewer, FreelancerProfile profile) async {
    _profiles[viewer] = profile;
  }
}
