import 'package:flutter/material.dart';
import 'package:workly/core/assets/figma_assets.dart';
import 'package:workly/features/auth/presentation/widgets/auth_components.dart';
import 'package:workly/features/auth/presentation/widgets/auth_motion.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({
    required this.index,
    required this.onNext,
    required this.onSkip,
    super.key,
  });
  final int index;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  static const pages = [
    (
      '585:4121',
      'KHÁM PHÁ',
      'Cơ hội mới, không giới hạn.',
      'Khám phá dự án và cộng sự phù hợp với tài năng của bạn.',
      'imgF02GiiThiungDng',
    ),
    (
      '599:3985',
      'HỢP TÁC',
      'Hợp tác rõ ràng, từng bước.',
      'Từ trao đổi, hợp đồng đến milestone và bàn giao trong cùng một nơi.',
      'imgF02BOnboardingHpTac',
    ),
    (
      '599:4000',
      'PHÁT TRIỂN',
      'Cùng nhau tạo nên điều tốt hơn.',
      'Kết nối Freelancer và Client để biến ý tưởng thành kết quả.',
      'imgF02COnboardingThanhCong',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final page = pages[index];
    return AuthPage(
      dark: true,
      background: Stack(
        fit: StackFit.expand,
        children: [
          FigmaAsset(page.$1, page.$5, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66064E3B),
                  Color(0x0A064E3B),
                  Color(0x7A064E3B),
                  Color(0xFA064E3B),
                ],
                stops: [0, 0.3, 0.55, 1],
              ),
            ),
          ),
        ],
      ),
      action: AuthAction(
        label: index == 2 ? 'Bắt đầu ngay' : 'Tiếp tục',
        onPressed: onNext,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 44,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  AuthBrand(node: page.$1, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'workly',
                      style: authText(
                        18,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 74,
                    child: TextButton(
                      onPressed: onSkip,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(
                        'Bỏ qua',
                        style: authText(
                          13,
                          weight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, box) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: (box.maxHeight - 36).clamp(0, double.infinity),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AuthEntrance(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                page.$2,
                                style: authText(11, color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                page.$3,
                                style: authText(
                                  32,
                                  weight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                page.$4,
                                style: authText(
                                  14,
                                  color: Colors.white.withValues(
                                    alpha: index == 0 ? 1 : 0.84,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 16,
                                child: Row(
                                  children: [
                                    for (var i = 0; i < 3; i++) ...[
                                      if (i > 0) const SizedBox(width: 8),
                                      Container(
                                        width: i == index ? 32 : 8,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: i == index ? 1 : 0.35,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
