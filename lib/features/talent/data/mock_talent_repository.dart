import 'package:workly/features/talent/domain/talent_repository.dart';

class MockTalentRepository implements TalentRepository {
  final _invitations = <String, Set<String>>{};
  static const talent = [
    Talent(
      id: 'talent-demo-1',
      name: 'Minh Anh',
      fullName: 'Nguyễn Minh Anh',
      specialty: 'UI/UX & Design System',
      category: 'UI/UX',
      rating: '4.9',
      rate: 350000,
      completed: 24,
      skills: ['UI/UX', 'Figma', 'Prototype'],
      initials: 'MA',
      reviews: 28,
    ),
    Talent(
      id: 'talent-demo-2',
      name: 'Quốc Huy',
      fullName: 'Quốc Huy',
      specialty: 'Flutter / Android',
      category: 'Flutter',
      rating: '4.8',
      rate: 400000,
      completed: 18,
      skills: ['Flutter', 'Dart'],
      initials: 'QH',
      photoSlot: 'imgEditorialRealPhotography1',
    ),
    Talent(
      id: 'talent-demo-3',
      name: 'Hà Linh',
      fullName: 'Hà Linh',
      specialty: 'Marketing & Branding',
      category: 'Marketing',
      rating: '4.9',
      rate: 280000,
      completed: 24,
      skills: ['Marketing', 'Branding'],
      initials: 'HL',
    ),
    Talent(
      id: 'talent-demo-4',
      name: 'Hoàng Nam',
      fullName: 'Trần Hoàng Nam',
      specialty: 'UI/UX · Prototype · Figma',
      category: 'UI/UX',
      rating: '4.8',
      rate: 350000,
      completed: 24,
      skills: ['UI/UX', 'Prototype', 'Figma'],
      initials: 'HN',
      projectPrice: 10000000,
      reviews: 36,
    ),
    Talent(
      id: 'talent-demo-5',
      name: 'Thu Hà',
      fullName: 'Lê Thu Hà',
      specialty: 'Branding · Illustrator',
      category: 'Branding',
      rating: '4.9',
      rate: 280000,
      completed: 24,
      skills: ['Branding', 'Illustrator'],
      initials: 'TH',
      projectPrice: 6500000,
      reviews: 42,
    ),
    Talent(
      id: 'talent-demo-6',
      name: 'Gia Bảo',
      fullName: 'Phạm Gia Bảo',
      specialty: 'Figma · Web Design',
      category: 'UI/UX',
      rating: '4.8',
      rate: 350000,
      completed: 24,
      skills: ['Figma', 'Web Design'],
      initials: 'GB',
      projectPrice: 8000000,
      reviews: 21,
    ),
  ];
  @override
  Future<List<Talent>> fetchTalent() async => talent;
  @override
  Future<void> invite(String viewer, Set<String> ids) async {
    _invitations.putIfAbsent(viewer, () => {}).addAll(ids);
  }
}
