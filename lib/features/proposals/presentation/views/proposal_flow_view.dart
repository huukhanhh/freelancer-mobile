import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/core/theme/design_tokens.dart';
import 'package:workly/core/widgets/project_components.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/projects/domain/project_repository.dart';
import 'package:workly/features/proposals/presentation/view_models/proposal_view_model.dart';

enum ProposalStage { start, screening, letter, quote, preview, success }

class ProposalFlowView extends StatelessWidget {
  const ProposalFlowView({
    required this.model,
    required this.stage,
    required this.onBack,
    required this.onHome,
    required this.onNext,
    required this.onMine,
    required this.onEdit,
    this.onPortfolio,
    super.key,
  });
  final ProposalViewModel model;
  final ProposalStage stage;
  final VoidCallback onBack, onHome, onNext, onMine;
  final ValueChanged<ProposalStage> onEdit;
  final VoidCallback? onPortfolio;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) {
      final d = model.draft;
      if (d == null) return const SizedBox.shrink();
      if (stage == ProposalStage.screening) {
        return _Screening(
          model: model,
          onBack: onMine,
          onHome: onHome,
          onContinue: onNext,
          onLetter: () => onEdit(ProposalStage.letter),
        );
      }
      final title = switch (stage) {
        ProposalStage.start => 'Ứng tuyển dự án',
        ProposalStage.preview => 'Xem trước đề xuất',
        ProposalStage.success => 'Đề xuất của tôi',
        _ => 'Viết đề xuất',
      };
      final label = switch (stage) {
        ProposalStage.start => 'Bắt đầu viết đề xuất',
        ProposalStage.letter => 'Tiếp tục · Báo giá',
        ProposalStage.quote => 'Xem trước đề xuất',
        ProposalStage.preview => model.busy ? 'Đang gửi…' : 'Gửi đề xuất',
        _ => 'Theo dõi đề xuất',
      };
      return ProjectPage(
        title: title,
        contextHeader: true,
        onBack: onBack,
        onHome: onHome,
        action: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProjectAction(
              label: label,
              onPressed: model.busy
                  ? null
                  : () {
                      FocusScope.of(context).unfocus();
                      if (stage == ProposalStage.letter &&
                          !model.validateLetter()) {
                        return;
                      }
                      if (stage == ProposalStage.quote &&
                          !model.validateQuote()) {
                        return;
                      }
                      onNext();
                    },
            ),
            const SizedBox(height: 12),
            ProjectAction(
              label: 'Về đề xuất của tôi',
              onPressed: onMine,
              outline: true,
            ),
          ],
        ),
        child: ListView(
          key: PageStorageKey(stage),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [
            if (stage == ProposalStage.start) ..._start(d),
            if (stage == ProposalStage.letter) ..._letter(d),
            if (stage == ProposalStage.quote) ..._quote(d),
            if (stage == ProposalStage.preview) ..._preview(d),
            if (stage == ProposalStage.success) ..._success(d),
            if (d.error != null) ...[
              const SizedBox(height: 12),
              Text(
                d.error!,
                style: authText(13, color: const Color(0xFFBA1A1A)),
              ),
            ],
          ],
        ),
      );
    },
  );
  List<Widget> _start(ProposalDraft d) => _space([
    _heading('Cơ hội hợp tác mới'),
    _body(
      'Giới thiệu cách bạn có thể giúp ${d.project.title.replaceFirst('Phát triển ứng dụng ', '')}.',
    ),
    ProposalProjectSummary(
      project: d.project,
      node: '585:7372',
      slot: 'imgProjectCoverThumbnail',
      budget: d.project.budget,
      days: d.project.days,
    ),
    _role(d),
    _section('Chuẩn bị đề xuất'),
    const ProjectCard(
      children: [
        ProposalTimeline(
          titles: ['Thư giới thiệu', 'Giá & thời gian', 'Portfolio phù hợp'],
          descriptions: [
            'Cách tiếp cận và phạm vi bàn giao.',
            'Báo giá và thời điểm sẵn sàng bắt đầu.',
            'Đính kèm dự án Mây từ hồ sơ của bạn.',
          ],
        ),
      ],
    ),
    const ProjectNotice(
      'Hoàn thiện nội dung rồi xem lại toàn bộ đề xuất trước khi gửi cho Client.',
      heading: 'Bạn được kiểm tra trước khi gửi',
      check: false,
    ),
  ]);
  List<Widget> _letter(ProposalDraft d) => _space([
    const ProposalStepper(1),
    _heading('Giới thiệu thế mạnh'),
    _body('Một lời đề xuất dành riêng cho nhu cầu của Client.'),
    _role(d),
    ProposalProjectSummary(
      project: d.project,
      node: '585:7424',
      slot: 'imgPortfolioCover',
    ),
    ProposalInput(
      label: 'Thư giới thiệu *',
      value: d.letter,
      onChanged: model.changeLetter,
      multiline: true,
    ),
    _caption(
      'Nêu cách tiếp cận, kinh nghiệm liên quan và kết quả bạn sẽ bàn giao.',
    ),
    _section('Portfolio đính kèm'),
    const ProposalPortfolio(),
    ProjectAction(
      label: 'Chọn thêm từ portfolio',
      onPressed: onPortfolio,
      outline: true,
    ),
  ]);
  List<Widget> _quote(ProposalDraft d) => _space([
    const ProposalStepper(2),
    _heading('Báo giá & thời gian'),
    _body('Đặt kỳ vọng rõ ràng cho phạm vi bạn đề xuất.'),
    _role(d),
    ProposalProjectSummary(
      project: d.project,
      node: '585:7456',
      slot: 'imgProjectCoverThumbnail',
    ),
    ProposalInput(
      label: 'Giá đề xuất (VNĐ) *',
      value: d.price,
      onChanged: (v) => model.changeQuote(price: v),
      numeric: true,
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ProposalInput(
            label: 'Thời gian *',
            value: d.days,
            onChanged: (v) => model.changeQuote(days: v),
            numeric: true,
            suffix: ' ngày',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ProposalInput(
            label: 'Bắt đầu từ *',
            value: d.startDate,
            onChanged: (v) => model.changeQuote(startDate: v),
          ),
        ),
      ],
    ),
    ProposalQuote(d),
    const ProjectNotice(
      'Điều khoản, mốc công việc và thanh toán được xác nhận ở bước chuẩn bị hợp đồng.',
      heading: 'Thống nhất khi soạn hợp đồng',
      check: false,
    ),
  ]);
  List<Widget> _preview(ProposalDraft d) => _space([
    const ProposalStepper(3),
    _heading('Đề xuất của Minh Anh'),
    _caption('DX-DEMO · ${d.project.code} · Gửi đến ${d.project.owner}'),
    _role(d),
    ProposalProjectSummary(
      project: d.project,
      node: '585:7496',
      slot: 'imgPortfolioCover',
      status: null,
    ),
    _editable('Báo giá & lịch làm việc', () => onEdit(ProposalStage.quote)),
    ProposalQuote(d),
    _editable('Thư giới thiệu', () => onEdit(ProposalStage.letter)),
    ProjectCard(
      children: [
        Text(
          'Gửi anh ${d.project.owner},',
          style: authText(13, weight: FontWeight.w500),
        ),
        _body(d.letter),
      ],
    ),
    ProjectCard(
      children: [
        Row(
          children: [
            const FigmaAsset('585:7496', 'imgEllipse', width: 56, height: 56),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nguyễn Minh Anh',
                    style: authText(18, weight: FontWeight.w700),
                  ),
                  _caption('UI/UX Designer'),
                  Text(
                    '★ 4,9 · 12 đánh giá',
                    style: authText(11, color: EmeraldColors.primaryDark),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
    _section('Phạm vi bàn giao'),
    const ProjectCard(
      children: [
        ProposalTimeline(
          titles: [
            'Khám phá & wireframe',
            'UI & prototype',
            'Hoàn thiện & bàn giao',
          ],
          descriptions: [
            'Làm rõ nhu cầu, thiết kế các luồng chính.',
            'Giao diện iOS/Android và prototype tương tác.',
            'File Figma, component và hướng dẫn sử dụng.',
          ],
        ),
      ],
    ),
    _editable('Portfolio đã chọn', () => onEdit(ProposalStage.letter)),
    const ProposalPortfolio(),
    _caption(
      'Đề xuất chưa tạo hợp đồng. Client có thể trao đổi thêm trước khi quyết định.',
    ),
  ]);
  List<Widget> _success(ProposalDraft d) => _space([
    const SizedBox(
      height: 172,
      child: Center(
        child: SizedBox(
          width: 200,
          height: 172,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: -24,
                top: -32,
                width: 248,
                height: 248,
                child: FigmaAsset('585:7537', 'imgProjectsSuccessGlowingCheck'),
              ),
            ],
          ),
        ),
      ),
    ),
    Text(
      'Đề xuất đã được gửi!',
      textAlign: TextAlign.center,
      style: authText(21, weight: FontWeight.w700),
    ),
    Text(
      'Minh Anh, đề xuất của bạn đã được gửi đến anh ${d.project.owner}.',
      textAlign: TextAlign.center,
      style: authText(14, color: EmeraldColors.textSecondary),
    ),
    ProjectNotice(
      'Hợp đồng riêng cho vị trí ${d.vacancy.title} · Nguyễn Minh Anh · Báo giá ${formatDong(d.amount)}.',
      heading: 'Ứng tuyển theo vai trò',
      check: false,
    ),
    ProposalProjectSummary(
      project: d.project,
      node: '585:7537',
      slot: 'imgProjectCoverThumbnail',
      status: 'Đã gửi',
      code: model.sent?.id,
      budget: d.amount,
      days: d.duration,
    ),
    const ProjectNotice(
      'Client có thể nhắn tin trao đổi thêm. Việc gửi đề xuất chưa đồng nghĩa với được chấp nhận.',
      heading: 'Đang chờ Client xem',
      check: false,
    ),
  ]);
  Widget _role(ProposalDraft d) => ProjectNotice(
    'Vị trí ${d.vacancy.title} · Ngân sách ${formatDong(d.vacancy.budget)} / người',
    heading: 'Ứng tuyển theo vai trò',
    check: false,
  );
  Widget _editable(String title, VoidCallback edit) => Row(
    children: [
      Expanded(child: _section(title)),
      TextButton(
        onPressed: edit,
        style: TextButton.styleFrom(
          foregroundColor: EmeraldColors.primaryDark,
          padding: EdgeInsets.zero,
          minimumSize: const Size(44, 28),
        ),
        child: Text(
          'Sửa',
          style: authText(
            13,
            weight: FontWeight.w500,
            color: EmeraldColors.primaryDark,
          ),
        ),
      ),
    ],
  );
}

List<Widget> _space(List<Widget> items) => [
  for (var i = 0; i < items.length; i++) ...[
    if (i > 0) const SizedBox(height: 12),
    items[i],
  ],
];
Widget _heading(String s) =>
    Text(s, style: authText(21, weight: FontWeight.w700));
Widget _body(String s) =>
    Text(s, style: authText(14, color: EmeraldColors.textSecondary));
Widget _section(String s) =>
    Text(s, style: authText(18, weight: FontWeight.w700));
Widget _caption(String s) =>
    Text(s, style: authText(11, color: EmeraldColors.textSecondary));

class ProposalStepper extends StatelessWidget {
  const ProposalStepper(this.step, {super.key});
  final int step;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Text(
            'Bước $step/3',
            style: authText(
              13,
              weight: FontWeight.w500,
              color: EmeraldColors.primaryDark,
            ),
          ),
          Expanded(
            child: Text(
              ['Thư giới thiệu', 'Báo giá & thời gian', 'Kiểm tra & gửi'][step -
                  1],
              textAlign: TextAlign.right,
              style: authText(
                13,
                weight: FontWeight.w500,
                color: EmeraldColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          for (var i = 1; i <= 3; i++) ...[
            if (i > 1) const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: i <= step
                      ? EmeraldColors.primary
                      : ProfileTokens.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ],
        ],
      ),
    ],
  );
}

class ProposalProjectSummary extends StatelessWidget {
  const ProposalProjectSummary({
    required this.project,
    required this.node,
    required this.slot,
    this.status = 'Đang tuyển',
    this.code,
    this.budget,
    this.days,
    this.action,
    super.key,
  });
  final Project project;
  final String node, slot;
  final String? status, code;
  final int? budget, days;
  final Widget? action;
  @override
  Widget build(BuildContext context) => ProjectCard(
    children: [
      if (status != null)
        Row(
          children: [
            Container(
              width: 110,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: EmeraldColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                status!,
                style: authText(11, color: EmeraldColors.primaryDark),
              ),
            ),
            Expanded(
              child: Text(
                code ?? project.code,
                textAlign: TextAlign.right,
                style: authText(11, color: EmeraldColors.textSecondary),
              ),
            ),
          ],
        ),
      ProjectIdentity(
        project,
        width: 112,
        height: 80,
        fontSize: 18,
        node: project.code == 'P-024' ? node : null,
        slot: project.code == 'P-024' ? slot : null,
      ),
      if (budget != null)
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _caption(
                    status == 'Đang tuyển' ? 'Ngân sách' : 'Giá đề xuất',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDong(budget!),
                    style: authText(
                      13,
                      weight: FontWeight.w500,
                      color: EmeraldColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _caption('Thời gian'),
                  const SizedBox(height: 4),
                  Text(
                    '$days ngày',
                    style: authText(13, weight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ?action,
    ],
  );
}

class ProposalQuote extends StatelessWidget {
  const ProposalQuote(this.draft, {super.key});
  final ProposalDraft draft;
  @override
  Widget build(BuildContext context) => ProjectCard(
    color: EmeraldColors.surfaceSubtle,
    children: [
      Text(
        'BÁO GIÁ TRỌN GÓI',
        style: authText(11, color: EmeraldColors.primaryDark),
      ),
      Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatDong(draft.amount),
                  style: authText(
                    21,
                    weight: FontWeight.w700,
                    color: EmeraldColors.primaryDark,
                  ),
                ),
                _caption('Cho phạm vi đã đề xuất'),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${draft.duration} ngày',
                  style: authText(18, weight: FontWeight.w700),
                ),
                _caption('Thời gian thực hiện'),
              ],
            ),
          ),
        ],
      ),
      Text(draft.dates, style: authText(13, weight: FontWeight.w500)),
    ],
  );
}

class ProposalTimeline extends StatelessWidget {
  const ProposalTimeline({
    required this.titles,
    required this.descriptions,
    super.key,
  });
  final List<String> titles, descriptions;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var i = 0; i < titles.length; i++)
        SizedBox(
          height: 76,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: EmeraldColors.surfaceSubtle,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '0${i + 1}',
                        style: authText(11, color: EmeraldColors.primaryDark),
                      ),
                    ),
                    if (i < titles.length - 1) ...[
                      const SizedBox(height: 4),
                      Container(
                        width: 2,
                        height: 28,
                        color: ProfileTokens.border,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titles[i],
                      style: authText(13, weight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    _caption(descriptions[i]),
                  ],
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

class ProposalPortfolio extends StatelessWidget {
  const ProposalPortfolio({super.key});
  @override
  Widget build(BuildContext context) => ProjectCard(
    children: [
      Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const FigmaAsset(
              '585:7424',
              'imgPortfolioCover',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ứng dụng chi tiêu Mây',
                  style: authText(13, weight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                _caption('UI/UX · Fintech · Mobile App'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const FigmaAsset(
                      '585:7424',
                      'imgProfileIconCheck',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Đã đính kèm từ hồ sơ',
                        style: authText(11, color: EmeraldColors.primaryDark),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

class ProposalInput extends StatelessWidget {
  const ProposalInput({
    required this.label,
    required this.value,
    required this.onChanged,
    this.multiline = false,
    this.numeric = false,
    this.suffix,
    super.key,
  });
  final String label, value;
  final ValueChanged<String> onChanged;
  final bool multiline, numeric;
  final String? suffix;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        style: authText(
          13,
          weight: FontWeight.w500,
          color: EmeraldColors.textSecondary,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        initialValue: value,
        onChanged: onChanged,
        keyboardType: multiline
            ? TextInputType.multiline
            : numeric
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: numeric
            ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))]
            : null,
        minLines: multiline ? 13 : 1,
        maxLines: multiline ? null : 1,
        style: authText(14),
        decoration: InputDecoration(
          suffixText: suffix,
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
    ],
  );
}

class _Screening extends StatelessWidget {
  const _Screening({
    required this.model,
    required this.onBack,
    required this.onHome,
    required this.onContinue,
    required this.onLetter,
  });
  final ProposalViewModel model;
  final VoidCallback onBack, onHome, onContinue, onLetter;
  @override
  Widget build(BuildContext context) {
    final d = model.draft!;
    return ProjectPage(
      title: 'Câu hỏi từ Client',
      onBack: onBack,
      onHome: onHome,
      action: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProjectAction(
            label: 'Tiếp theo',
            solid: true,
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (model.nextQuestion()) onContinue();
            },
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              if (!model.previousQuestion()) onLetter();
            },
            child: Text(
              d.question == 0 ? 'Quay lại thư giới thiệu' : 'Câu trước',
              style: authText(
                14,
                weight: FontWeight.w500,
                color: EmeraldColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
      child: ColoredBox(
        color: const Color(0xFFF8FAFC),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Câu ${d.question + 1}/3',
                    style: authText(
                      14,
                      weight: FontWeight.w500,
                      color: EmeraldColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      for (var i = 0; i < 3; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        Container(
                          width: 58.8,
                          height: 4,
                          decoration: BoxDecoration(
                            color: i <= d.question
                                ? EmeraldColors.primaryDark
                                : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ProjectIdentity(
              d.project,
              node: d.project.code == 'P-024' ? '585:7830' : null,
              slot: d.project.code == 'P-024'
                  ? 'imgProjectCoverThumbnail'
                  : null,
              fontSize: 12,
            ),
            const SizedBox(height: 8),
            Text(
              ProposalViewModel.questions[d.question],
              style: authText(
                16,
                weight: FontWeight.w500,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: d.answerError ? 215 : 188,
              child: TextFormField(
                key: ValueKey(d.question),
                initialValue: d.answers[d.question],
                onChanged: model.answer,
                maxLength: 500,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: authText(14, color: const Color(0xFF475569)),
                decoration: InputDecoration(
                  hintText: 'Nhập câu trả lời của bạn…',
                  hintStyle: authText(
                    14,
                    weight: FontWeight.w500,
                    color: const Color(0xFF475569),
                  ),
                  errorText: d.answerError
                      ? 'Vui lòng trả lời câu hỏi này.'
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  counterText: '${d.answers[d.question].length}/500',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Trả lời cụ thể sẽ giúp Proposal nổi bật',
              style: authText(12, color: const Color(0xFF475569)),
            ),
          ],
        ),
      ),
    );
  }
}
