import 'package:workly/features/discovery/domain/job_repository.dart';
import 'package:workly/features/projects/domain/project_repository.dart';

/// Deterministic fixtures. Listing IDs resolve to their own project, never to an
/// unrelated GreenPay detail. GreenPay's three roles are from 585:4950.
class MockProjectRepository implements ProjectRepository {
  const MockProjectRepository(this.jobs);
  final JobRepository jobs;
  @override
  Future<ProjectManagement> fetchManagement() async => const ProjectManagement(
    received: 8,
    newProposals: 3,
    candidates: [
      (
        'Nguyễn Hoàng Anh',
        'UI/UX · Figma · Mobile App',
        'Có 3 năm kinh nghiệm thiết kế ứng dụng cho các startup fintech.',
        11500000,
        28,
        'NA',
      ),
      (
        'Lê Minh Trang',
        'UI/UX · Figma · Prototyping',
        'Chuyên thiết kế sản phẩm fintech, nghiên cứu UX và kiểm thử với người dùng.',
        13000000,
        30,
        'LT',
      ),
    ],
    attachments: [
      ('PDF', 'GreenPay-brief.pdf', '2,4 MB'),
      ('ZIP', 'brand-assets.zip', '6,8 MB'),
    ],
  );
  @override
  Future<List<Project>> fetchProjects() async {
    final listings = await jobs.fetchJobs();
    return List.unmodifiable(
      listings.map((job) {
        final greenPay = job.title.startsWith('GreenPay');
        return Project(
          id: job.id,
          code: greenPay ? 'P-024' : 'P-DEMO-${job.id.split('-').last}',
          title: greenPay ? 'Phát triển ứng dụng GreenPay' : job.title,
          owner: greenPay ? 'Trần Quốc Huy' : job.client.split(' · ').first,
          description: greenPay
              ? 'Xây dựng trải nghiệm, ứng dụng mobile và hệ thống API GreenPay. Chọn vị trí phù hợp để xem phạm vi và gửi đề xuất.'
              : '${job.title}. Chọn vị trí phù hợp để xem phạm vi và gửi đề xuất.',
          budget: greenPay ? 50000000 : job.budget,
          days: job.days,
          imageNode: greenPay ? '585:4950' : job.imageNode,
          imageSlot: greenPay ? 'imgProjectCover' : job.imageSlot,
          vacancies: greenPay
              ? const [
                  Vacancy(
                    'design',
                    'UI/UX',
                    12000000,
                    'Nghiên cứu, wireframe, UI và Figma',
                  ),
                  Vacancy(
                    'frontend',
                    'Frontend',
                    18000000,
                    'Ứng dụng mobile & tích hợp API',
                  ),
                  Vacancy(
                    'backend',
                    'Backend',
                    20000000,
                    'API, dữ liệu & triển khai',
                  ),
                ]
              : [
                  Vacancy(
                    'main',
                    job.skills.first,
                    job.budget,
                    job.skills.join(' · '),
                  ),
                ],
        );
      }),
    );
  }
}
