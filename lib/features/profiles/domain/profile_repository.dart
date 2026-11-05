class PortfolioEntry {
  const PortfolioEntry({
    required this.id,
    required this.title,
    required this.metadata,
    required this.node,
    required this.slot,
    this.role = 'UI/UX Designer',
    this.description = 'Thiết kế trải nghiệm quản lý chi tiêu cá nhân, từ nghiên cứu người dùng đến giao diện và prototype.',
    this.link = 'https://behance.net/your-project',
  });
  final String id, title, metadata, node, slot, role, description, link;
  PortfolioEntry copyWith({
    String? title,
    String? role,
    String? description,
    String? link,
    String? node,
    String? slot,
  }) => PortfolioEntry(
    id: id,
    title: title ?? this.title,
    metadata: metadata,
    node: node ?? this.node,
    slot: slot ?? this.slot,
    role: role ?? this.role,
    description: description ?? this.description,
    link: link ?? this.link,
  );
}

class FreelancerProfile {
  const FreelancerProfile({
    this.name = 'Nguyễn Minh Anh',
    this.title = 'UI/UX Designer',
    this.bio = 'Tôi thiết kế trải nghiệm số đơn giản, dễ dùng. 3 năm làm UI/UX cho ứng dụng tài chính và dịch vụ.',
    this.location = 'Hà Nội',
    this.rate = '450.000',
    this.company = 'Studio Mộc',
    this.position = 'UI/UX Designer',
    this.fromYear = '2023',
    this.toYear = '2026',
    this.workDescription = 'Thiết kế UI, ứng dụng di động và kiểm thử UX.',
    this.technologies = const {},
    required this.portfolio,
  });
  final String name,
      title,
      bio,
      location,
      rate,
      company,
      position,
      fromYear,
      toYear,
      workDescription;
  final Set<String> technologies;
  final List<PortfolioEntry> portfolio;
  FreelancerProfile updated(
    Map<String, String> f,
    Set<String> skills, {
    List<PortfolioEntry>? portfolio,
  }) => FreelancerProfile(
    name: name,
    title: f['title'] ?? title,
    bio: f['bio'] ?? bio,
    location: f['location'] ?? location,
    rate: f['rate'] ?? rate,
    company: f['company'] ?? company,
    position: f['position'] ?? position,
    fromYear: f['fromYear'] ?? fromYear,
    toYear: f['toYear'] ?? toYear,
    workDescription: f['workDescription'] ?? workDescription,
    technologies: Set.unmodifiable(skills),
    portfolio: List.unmodifiable(portfolio ?? this.portfolio),
  );
}

abstract interface class ProfileRepository {
  Future<FreelancerProfile> fetchProfile(String viewer);
  Future<void> saveProfile(String viewer, FreelancerProfile profile);
}
