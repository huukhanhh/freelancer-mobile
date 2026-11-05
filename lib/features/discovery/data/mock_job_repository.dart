import 'package:workly/features/discovery/domain/job_repository.dart';

class MockJobRepository implements JobRepository {
  MockJobRepository({this.unavailable = false});
  bool unavailable;
  static final _jobs = List<Job>.unmodifiable([
    for (var i = 0; i < 24; i++)
      Job(
        id: 'job-demo-${i + 1}',
        title:
            [
              'Flutter E-commerce App',
              'Thiết kế hệ thống bán hàng',
              'Mobile Banking UI',
              'GreenPay · Vị trí UI/UX',
              'React Admin Dashboard',
              'Landing page mỹ phẩm',
            ][i % 6] +
            (i >= 6 ? ' · Demo ${i + 1}' : ''),
        client: [
          'VietMarket · 11 ứng tuyển',
          'NovaTech · Đã xác minh',
          'FinCloud · Remote',
          'Quốc Huy Demo · Client độc lập',
          'Mộc Studio · Remote',
          'Lumi Agency · 12 ứng tuyển',
        ][i % 6],
        budget: [
          18000000,
          11000000,
          9500000,
          12000000,
          8000000,
          4500000,
        ][i % 6],
        skills: const [
          ['Flutter', 'Firebase'],
          ['Figma', 'Mobile UX'],
          ['UI/UX', 'Banking'],
          ['Figma', 'UI/UX'],
          ['React', 'TypeScript'],
          ['HTML/CSS', 'SEO'],
        ][i % 6],
        category: [
          'Web',
          'Thiết kế',
          'Thiết kế',
          'Thiết kế',
          'Web',
          'Web',
        ][i % 6],
        days: [30, 25, 20, 30, 20, 5][i % 6],
        imageNode: i % 6 < 3 ? '585:4873' : '585:4648',
        imageSlot: 'imgGenuineWorkspacePhoto${i % 3 == 0 ? '' : i % 3}',
        createdAt: 100 - i,
        verified: i % 7 != 6,
        remote: i % 5 != 4,
        hourly: i % 8 == 7,
      ),
  ]);
  @override
  Future<List<Job>> fetchJobs() async {
    if (unavailable) throw StateError('Mock jobs unavailable');
    return _jobs;
  }
}
