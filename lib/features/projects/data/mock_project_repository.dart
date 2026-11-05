import 'package:workly/features/discovery/domain/job_repository.dart';
import 'package:workly/features/projects/domain/project_repository.dart';

/// Deterministic fixtures. Listing IDs resolve to their own project, never to an
/// unrelated GreenPay detail. GreenPay's three roles are from 585:4950.
class MockProjectRepository implements ProjectRepository {
  MockProjectRepository(this.jobs);
  final _owned = <String, List<Project>>{};
  final JobRepository jobs;
  @override
  ProjectDraft newDraft() => ProjectDraft(
    fields: {
      'title': 'Phát triển ứng dụng GreenPay',
      'summary': 'Thiết kế trải nghiệm ví điện tử dễ dùng, rõ ràng và an toàn.',
      'description': 'Phát triển GreenPay gồm thiết kế UI/UX, Frontend mobile và Backend API. Mỗi vai trò có phạm vi, hợp đồng và nghiệm thu riêng.',
      'deliverables':
          'Wireframe, UI iOS/Android, prototype và bộ component Figma.',
      'priority': 'Ưu tiên freelancer có portfolio fintech và kinh nghiệm thiết kế ứng dụng di động.',
      'billing': 'Trọn gói · Fixed-price',
      'budget': '50.000.000',
      'start': '01/11/2026',
      'end': '30/11/2026',
    },
    skills: {'Figma', 'UI/UX', 'Mobile UX'},
    roles: [
      HiringRoleDraft(
        'Thiết kế UI/UX',
        '1',
        '12.000.000đ',
        'Nghiên cứu, wireframe, UI mobile và bàn giao Figma.',
      ),
      HiringRoleDraft(
        'Lập trình Frontend',
        '1',
        '18.000.000đ',
        'Phát triển giao diện ứng dụng, tích hợp API và kiểm thử phía người dùng.',
      ),
      HiringRoleDraft(
        'Lập trình Backend',
        '1',
        '20.000.000đ',
        'API, dữ liệu, xác thực và triển khai hệ thống.',
      ),
    ],
    files: [
      ('PDF', 'GreenPay-brief.pdf', '2,4 MB'),
      ('ZIP', 'brand-assets.zip', '6,8 MB'),
    ],
  );
  @override
  Future<List<Project>> fetchOwned(String viewer) async {
    if (!_owned.containsKey(viewer)) {
      final catalog = await fetchProjects();
      _owned[viewer] = [
        catalog.firstWhere((p) => p.id == 'job-demo-4'),
        const Project(
          id: 'client-web-025',
          code: 'P-025',
          title: 'Thiết kế website bán hàng',
          owner: 'Trần Quốc Huy',
          description: 'Thiết kế website bán hàng',
          budget: 8000000,
          days: 20,
          vacancies: [Vacancy('design', 'UI/UX', 8000000, 'Thiết kế website')],
          imageNode: '585:5813',
          imageSlot: 'imgProjectCoverThumbnail1',
        ),
      ];
    }
    return List.unmodifiable(_owned[viewer]!);
  }

  @override
  Future<void> saveOwned(String viewer, Project project) async {
    await fetchOwned(viewer);
    final rows = _owned[viewer]!;
    final index = rows.indexWhere((p) => p.id == project.id);
    if (index < 0) {
      rows.insert(0, project);
    } else {
      rows[index] = project;
    }
  }

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
          attachments: greenPay
              ? const [
                  ('PDF', 'GreenPay-brief.pdf', '2,4 MB'),
                  ('ZIP', 'brand-assets.zip', '6,8 MB'),
                ]
              : const [],
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
