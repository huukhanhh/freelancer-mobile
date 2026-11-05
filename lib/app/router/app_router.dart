import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workly/features/foundation/presentation/views/bootstrap_view.dart';
import 'package:workly/features/session/presentation/view_models/session_view_model.dart';
import 'package:workly/features/auth/presentation/view_models/auth_flow_view_model.dart';
import 'package:workly/features/auth/presentation/views/splash_view.dart';
import 'package:workly/features/auth/presentation/views/onboarding_view.dart';
import 'package:workly/features/auth/presentation/views/email_auth_view.dart';
import 'package:workly/features/auth/presentation/views/verification_view.dart';
import 'package:workly/features/auth/presentation/views/google_auth_view.dart';
import 'package:workly/features/auth/presentation/views/role_selection_view.dart';
import 'package:workly/features/auth/presentation/views/profile_setup_view.dart';
import 'package:workly/features/auth/presentation/views/recovery_view.dart';
import 'package:workly/features/home/domain/marketplace_repository.dart';
import 'package:workly/features/home/presentation/views/home_view.dart';
import 'package:workly/features/home/presentation/view_models/home_view_model.dart';
import 'package:workly/features/session/domain/user_session.dart';
import 'package:workly/features/discovery/presentation/view_models/discovery_view_model.dart';
import 'package:workly/features/discovery/presentation/views/job_discovery_view.dart';
import 'package:workly/features/discovery/presentation/views/job_filter_view.dart';

abstract final class AppRoutes {
  static const bootstrap = '/bootstrap';
  static const splash = '/auth/splash';
  static const login = '/auth/login',
      register = '/auth/register',
      verification = '/auth/verification';
  static const google = '/auth/google',
      role = '/auth/role',
      profile = '/auth/profile';
  static const recovery = '/auth/recovery', recovered = '/auth/recovered';
  static const clientHome = '/home/client', freelancerHome = '/home/freelancer';
  static const jobs = '/discovery/jobs',
      jobSearch = '/discovery/search',
      jobFilter = '/discovery/filter',
      jobResults = '/discovery/results',
      jobEmpty = '/discovery/empty';
  static String onboarding(int step) => '/auth/onboarding/$step';
}

String signedInDestination(SessionViewModel session) {
  final user = session.session;
  if (user == null) return AppRoutes.login;
  if (!user.profileComplete) return AppRoutes.role;
  return user.role == UserRole.client
      ? AppRoutes.clientHome
      : AppRoutes.freelancerHome;
}

Page<void> _discoveryPage(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      child: child,
      transitionsBuilder: (context, animation, secondary, child) =>
          MediaQuery.disableAnimationsOf(context)
          ? child
          : FadeTransition(
              opacity: animation.drive(
                CurveTween(curve: const Cubic(0, 0, .58, 1)),
              ),
              child: child,
            ),
    );

GoRouter createAppRouter(
  SessionViewModel session,
  AuthFlowViewModel auth,
  MarketplaceRepository marketplace, {
  String initialLocation = AppRoutes.splash,
  DiscoveryViewModel? discovery,
}) => GoRouter(
  initialLocation: initialLocation,
  refreshListenable: Listenable.merge([session, auth]),
  redirect: (context, state) {
    final path = state.uri.path;
    if (path == AppRoutes.splash &&
        auth.splashFinished &&
        session.status == SessionStatus.ready) {
      return session.session != null
          ? signedInDestination(session)
          : auth.onboardingSeen
          ? AppRoutes.login
          : AppRoutes.onboarding(0);
    }
    final home = path.startsWith('/home/');
    final jobRoute = path.startsWith('/discovery/');
    final setup = path == AppRoutes.role || path == AppRoutes.profile;
    if ((home || setup || jobRoute) && session.status == SessionStatus.ready) {
      final user = session.session;
      if (user == null) return AppRoutes.login;
      if (jobRoute &&
          (!user.profileComplete || user.role != UserRole.freelancer)) {
        return signedInDestination(session);
      }
      if (home || (setup && user.profileComplete)) {
        final target = signedInDestination(session);
        if (path != target) return target;
      }
      if (path == AppRoutes.profile && auth.selectedRole == null) {
        return AppRoutes.role;
      }
    }
    if (path == AppRoutes.verification && auth.email.isEmpty) {
      return AppRoutes.register;
    }
    return null;
  },
  routes: [
    if (discovery != null) ...[
      for (final entry in [
        (AppRoutes.jobs, JobDiscoveryMode.browse),
        (AppRoutes.jobSearch, JobDiscoveryMode.search),
        (AppRoutes.jobResults, JobDiscoveryMode.results),
      ])
        GoRoute(
          path: entry.$1,
          name: 'discovery.${entry.$2.name}',
          pageBuilder: (context, state) => _discoveryPage(
            state,
            JobDiscoveryView(
              model: discovery,
              mode: entry.$2,
              onBack: () => context.go(
                entry.$2 == JobDiscoveryMode.browse
                    ? AppRoutes.freelancerHome
                    : entry.$2 == JobDiscoveryMode.search
                    ? AppRoutes.jobs
                    : AppRoutes.jobSearch,
              ),
              onHome: () => context.go(AppRoutes.freelancerHome),
              onSearch: () => context.push(AppRoutes.jobSearch),
              onFilter: () => context.push(AppRoutes.jobFilter),
              onResults: () => context.go(
                discovery.results.isEmpty
                    ? AppRoutes.jobEmpty
                    : AppRoutes.jobResults,
              ),
            ),
          ),
        ),
      GoRoute(
        path: AppRoutes.jobFilter,
        name: 'discovery.filter',
        pageBuilder: (context, state) => _discoveryPage(
          state,
          JobFilterView(
            model: discovery,
            onBack: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.jobSearch);
              }
            },
            onApply: () => context.go(
              discovery.results.isEmpty
                  ? AppRoutes.jobEmpty
                  : AppRoutes.jobResults,
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.jobEmpty,
        name: 'discovery.empty',
        pageBuilder: (context, state) => _discoveryPage(
          state,
          EmptyDiscoveryView(
            onBack: () => context.go(AppRoutes.jobSearch),
            onHome: () => context.go(AppRoutes.freelancerHome),
            onSearch: (keyword) {
              discovery.search(keyword);
              context.go(
                discovery.results.isEmpty
                    ? AppRoutes.jobEmpty
                    : AppRoutes.jobResults,
              );
            },
            onExplore: () => context.go(AppRoutes.jobs),
          ),
        ),
      ),
    ],
    GoRoute(path: '/', redirect: (_, _) => AppRoutes.splash),
    GoRoute(
      path: AppRoutes.bootstrap,
      name: 'foundation.bootstrap',
      builder: (_, _) => BootstrapView(session: session),
    ),
    GoRoute(
      path: AppRoutes.splash,
      name: 'auth.splash',
      builder: (_, _) => SplashView(onReady: auth.finishSplash),
    ),
    GoRoute(
      path: '/auth/onboarding/:step',
      name: 'auth.onboarding',
      pageBuilder: (context, state) {
        final step = (int.tryParse(state.pathParameters['step'] ?? '0') ?? 0)
            .clamp(0, 2);
        void finish() {
          auth.finishOnboarding();
          context.go(AppRoutes.login);
        }

        return CustomTransitionPage(
          key: ValueKey('onboarding-$step'),
          transitionDuration: const Duration(milliseconds: 280),
          child: OnboardingView(
            index: step,
            onSkip: finish,
            onNext: step == 2
                ? finish
                : () => context.go(AppRoutes.onboarding(step + 1)),
          ),
          transitionsBuilder: (context, animation, secondary, child) =>
              MediaQuery.disableAnimationsOf(context)
              ? child
              : SlideTransition(
                  position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                      .animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: const Cubic(0, 0, .58, 1),
                        ),
                      ),
                  child: child,
                ),
        );
      },
    ),
    for (final registration in [false, true])
      GoRoute(
        path: registration ? AppRoutes.register : AppRoutes.login,
        name: registration ? 'auth.register' : 'auth.login',
        builder: (context, _) => EmailAuthView(
          model: auth,
          register: registration,
          onBack: () => context.go(
            registration ? AppRoutes.login : AppRoutes.onboarding(2),
          ),
          onAlternate: () {
            auth.clearError();
            context.go(registration ? AppRoutes.login : AppRoutes.register);
          },
          onGoogle: () => context.push(
            '${AppRoutes.google}?from=${registration ? 'register' : 'login'}',
          ),
          onRecovery: () {
            auth.beginRecovery();
            context.go(AppRoutes.recovery);
          },
          onComplete: () => context.go(
            registration || auth.authentication.needsVerification
                ? AppRoutes.verification
                : signedInDestination(session),
          ),
        ),
      ),
    GoRoute(
      path: AppRoutes.verification,
      name: 'auth.verification',
      builder: (context, _) => VerificationView(
        model: auth,
        onBack: () => context.go(AppRoutes.register),
        onLogin: () => context.go(AppRoutes.login),
      ),
    ),
    GoRoute(
      path: AppRoutes.google,
      name: 'auth.google',
      builder: (context, state) => GoogleAuthView(
        model: auth,
        onBack: () => context.go(
          state.uri.queryParameters['from'] == 'register'
              ? AppRoutes.register
              : AppRoutes.login,
        ),
        onComplete: () {
          if (context.mounted) context.go(signedInDestination(session));
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.role,
      name: 'auth.role',
      builder: (context, _) => RoleSelectionView(
        model: auth,
        onBack: () async {
          if (await auth.signOut() && context.mounted) {
            context.go(AppRoutes.login);
          }
        },
        onContinue: () => context.go(AppRoutes.profile),
      ),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'auth.profile',
      builder: (context, _) => ProfileSetupView(
        model: auth,
        role: auth.selectedRole ?? UserRole.freelancer,
        onBack: () => context.go(AppRoutes.role),
        onComplete: () => context.go(signedInDestination(session)),
      ),
    ),
    GoRoute(
      path: AppRoutes.recovery,
      name: 'auth.recovery',
      builder: (context, _) => RecoveryView(
        model: auth,
        onBack: () => context.go(AppRoutes.login),
        onSuccess: () => context.go(AppRoutes.recovered),
      ),
    ),
    GoRoute(
      path: AppRoutes.recovered,
      name: 'auth.recovered',
      builder: (context, _) => RecoverySuccessView(
        email: auth.email,
        onLogin: () => context.go(AppRoutes.login),
      ),
    ),
    for (final path in [AppRoutes.clientHome, AppRoutes.freelancerHome])
      GoRoute(
        path: path,
        name: path == AppRoutes.clientHome ? 'home.client' : 'home.freelancer',
        builder: (context, _) => session.session == null
            ? const SizedBox.shrink()
            : HomeView(
                model: HomeViewModel(
                  user: session.session!,
                  repository: marketplace,
                ),
                onSearch:
                    discovery == null ||
                        session.session!.role != UserRole.freelancer
                    ? null
                    : () => context.push(AppRoutes.jobSearch),
                onFilter:
                    discovery == null ||
                        session.session!.role != UserRole.freelancer
                    ? null
                    : () => context.push(AppRoutes.jobFilter),
                onExplore:
                    discovery == null ||
                        session.session!.role != UserRole.freelancer
                    ? null
                    : () => context.go(AppRoutes.jobs),
                onCategory:
                    discovery == null ||
                        session.session!.role != UserRole.freelancer
                    ? null
                    : (value) {
                        if ([
                          'React',
                          'Flutter',
                          'Python',
                          'Figma',
                        ].contains(value)) {
                          discovery.search(value);
                        } else {
                          discovery.category(value);
                        }
                        context.go(
                          discovery.results.isEmpty
                              ? AppRoutes.jobEmpty
                              : AppRoutes.jobResults,
                        );
                      },
                onTab:
                    discovery == null ||
                        session.session!.role != UserRole.freelancer
                    ? null
                    : (index) {
                        if (index == 0) {
                          context.go(AppRoutes.freelancerHome);
                        } else if (index == 1) {
                          context.go(AppRoutes.jobs);
                        }
                      },
              ),
      ),
  ],
  errorBuilder: (_, _) => const Scaffold(body: SizedBox.expand()),
);
