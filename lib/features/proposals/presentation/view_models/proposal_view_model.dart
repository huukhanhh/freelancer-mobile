import 'package:flutter/foundation.dart';
import 'package:workly/features/projects/domain/project_repository.dart';
import 'package:workly/features/proposals/domain/proposal_repository.dart';

class ProposalDraft {
  ProposalDraft(this.project, this.vacancy)
    : price = vacancy.budget.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (m) => '${m[1]}.',
      ),
      days = project.days.toString(),
      letter = vacancy.id == 'design' ? sampleLetter : '';
  final Project project;
  final Vacancy vacancy;
  String price, days, letter, startDate = '01/11/2026';
  final answers = ['', '', ''];
  int question = 0;
  bool answerError = false;
  String? error;
  static const sampleLetter =
      'Chào anh Huy, tôi là Minh Anh, nhà thiết kế UI/UX với 3 năm kinh nghiệm.\n\nVới GreenPay, tôi sẽ làm rõ nhu cầu, xây dựng wireframe cho đăng ký, chuyển tiền, QR và lịch sử giao dịch; sau đó hoàn thiện UI iOS/Android, prototype và bộ component Figma.\n\nPortfolio Mây thể hiện cách tôi xây dựng trải nghiệm đơn giản, rõ ràng. Mong được trao đổi cùng anh.';
  int get amount => RegExp(r'^\d[\d.,]*$').hasMatch(price.trim())
      ? int.tryParse(price.replaceAll(RegExp(r'[.,]'), '').trim()) ?? 0
      : 0;
  int get duration => int.tryParse(days.replaceAll(' ngày', '').trim()) ?? 0;
  DateTime? get start {
    final parts = startDate.split('/');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]),
        month = int.tryParse(parts[1]),
        year = int.tryParse(parts[2]);
    if (day == null ||
        month == null ||
        year == null ||
        year < 1 ||
        year > 9999) {
      return null;
    }
    final date = DateTime(year, month, day);
    return date.year == year && date.month == month && date.day == day
        ? date
        : null;
  }

  String get dates {
    final date = start;
    if (date == null || duration < 1) return startDate;
    DateTime end;
    try {
      end = date.add(Duration(days: duration - 1));
    } on ArgumentError {
      return startDate;
    }
    return '$startDate → ${end.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}/${end.year}';
  }
}

class ProposalViewModel extends ChangeNotifier {
  ProposalViewModel(this.repository);
  final ProposalRepository repository;
  String _viewer = '';
  int _generation = 0;
  bool _disposed = false, busy = false;
  final _drafts = <String, ProposalDraft>{};
  List<Proposal> proposals = const [];
  ProposalDraft? draft;
  Proposal? sent;
  String status = 'Đang chờ';
  List<Proposal> get filtered =>
      proposals.where((p) => p.status == status).toList();
  static const questions = [
    'Bạn đã từng thiết kế app giao đồ ăn hoặc sản phẩm tương tự chưa?',
    'Bạn sẽ làm gì để người dùng đặt món nhanh và dễ dàng?',
    'Bạn dự kiến phối hợp với Client và bàn giao thiết kế như thế nào?',
  ];
  Future<void> setViewer(String viewer) async {
    if (viewer == _viewer) return;
    _viewer = viewer;
    final gen = ++_generation;
    _drafts.clear();
    draft = null;
    sent = null;
    proposals = [];
    busy = false;
    status = 'Đang chờ';
    notifyListeners();
    if (viewer.isEmpty) return;
    final result = await repository.fetchProposals(viewer);
    if (_disposed || gen != _generation) return;
    proposals = result;
    notifyListeners();
  }

  void begin(Project project, Vacancy vacancy) {
    draft = _drafts.putIfAbsent(
      '${project.id}/${vacancy.id}',
      () => ProposalDraft(project, vacancy),
    );
    notifyListeners();
  }

  void selectStatus(String value) {
    status = value;
    notifyListeners();
  }

  void answer(String value) {
    draft!.answers[draft!.question] = value;
    draft!.answerError = false;
    notifyListeners();
  }

  bool nextQuestion() {
    final d = draft!;
    if (d.answers[d.question].trim().isEmpty) {
      d.answerError = true;
      notifyListeners();
      return false;
    }
    if (d.question < 2) {
      d.question++;
      d.answerError = false;
      notifyListeners();
      return false;
    }
    return true;
  }

  bool previousQuestion() {
    final d = draft!;
    if (d.question == 0) return false;
    d.question--;
    d.answerError = false;
    notifyListeners();
    return true;
  }

  void changeLetter(String value) {
    draft!.letter = value;
    draft!.error = null;
    notifyListeners();
  }

  void changeQuote({String? price, String? days, String? startDate}) {
    final d = draft!;
    if (price != null) d.price = price;
    if (days != null) d.days = days;
    if (startDate != null) d.startDate = startDate;
    d.error = null;
    notifyListeners();
  }

  bool validateLetter() {
    final d = draft!;
    d.error = d.letter.trim().isEmpty ? 'Vui lòng nhập thư giới thiệu.' : null;
    notifyListeners();
    return d.error == null;
  }

  bool validateQuote() {
    final d = draft!;
    d.error = d.amount <= 0
        ? 'Vui lòng nhập giá đề xuất hợp lệ.'
        : d.duration <= 0 || d.duration > 100000000
        ? 'Vui lòng nhập thời gian hợp lệ.'
        : d.start == null
        ? 'Nhập ngày hợp lệ theo định dạng dd/MM/yyyy.'
        : null;
    notifyListeners();
    return d.error == null;
  }

  Future<bool> submit() async {
    if (busy || draft == null || _viewer.isEmpty) return false;
    if (!validateLetter() || !validateQuote()) return false;
    final d = draft!;
    if (d.answers.any((a) => a.trim().isEmpty)) {
      d.error = 'Vui lòng hoàn tất câu hỏi từ Client.';
      notifyListeners();
      return false;
    }
    final gen = _generation;
    busy = true;
    notifyListeners();
    try {
      final result = await repository.submit(
        _viewer,
        d.project,
        d.vacancy,
        price: d.amount,
        days: d.duration,
        startDate: d.startDate,
        letter: d.letter.trim(),
        answers: d.answers,
      );
      if (_disposed || gen != _generation) return false;
      sent = result;
      final rows = await repository.fetchProposals(_viewer);
      if (_disposed || gen != _generation) return false;
      proposals = rows;
      return true;
    } catch (_) {
      if (!_disposed && gen == _generation) {
        d.error = 'Chưa gửi được đề xuất. Vui lòng thử lại.';
      }
      return false;
    } finally {
      if (!_disposed && gen == _generation) {
        busy = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    super.dispose();
  }
}
