import 'package:workly/features/talent/presentation/view_models/talent_view_model.dart';
import 'package:workly/features/talent/presentation/views/talent_views.dart';
import 'package:workly/features/projects/presentation/views/client_project_view.dart';
import 'package:workly/features/profiles/presentation/view_models/profile_view_model.dart';
import 'package:workly/features/profiles/presentation/views/profile_views.dart';
import 'package:workly/features/discovery/presentation/views/saved_jobs_view.dart';
import 'package:workly/features/projects/presentation/view_models/projects_view_model.dart';
import 'package:workly/features/projects/presentation/views/project_detail_view.dart';
import 'package:workly/features/proposals/presentation/view_models/proposal_view_model.dart';
import 'package:workly/features/proposals/presentation/views/proposal_flow_view.dart';
import 'package:workly/features/proposals/presentation/views/my_proposals_view.dart';
import 'package:flutter/material.dart';
import 'package:workly/core/theme/design_tokens.dart';
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
  static const talentBrowse = '/talent/browse',
      talentCompare = '/talent/compare',
      talentInvite = '/talent/invite',
      clientProject = '/client/projects/greenpay';
  static String talentProfile(String id) => '/talent/profile/$id';
  static const freelancerProfile = '/profiles/freelancer',
      profileEdit = '/profiles/freelancer/edit',
      profileSkills = '/profiles/freelancer/skills',
      profilePreview = '/profiles/freelancer/preview',
      portfolio = '/profiles/portfolio',
      savedJobs = '/discovery/saved';
  static String portfolioEdit(String? id) =>
      '/profiles/portfolio/edit/${id ?? 'new'}';
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
  static const myProposals = '/proposals/mine',
      sentProposals = '/proposals/sent';
  static String project(String id) => '/projects/jobs/$id';
  static String vacancies(String id) => '/proposals/$id/positions';
  static String proposal(String id, ProposalStage stage) =>
      '/proposals/$id/${stage.name}';
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
  ProjectsViewModel? projects,
  ProposalViewModel? proposals,
  ProfileViewModel? profile,
  TalentViewModel? talent,
}) => GoRouter(
  initialLocation: initialLocation,
  refreshListenable: Listenable.merge([session, auth, ?projects]),
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
    final jobRoute =
        path.startsWith('/discovery/') ||
        path.startsWith('/projects/') ||
        path.startsWith('/proposals/') ||
        path.startsWith('/profiles/');
    final clientRoute =
        path.startsWith('/talent/') || path.startsWith('/client/');
    final setup = path == AppRoutes.role || path == AppRoutes.profile;
    if ((home || setup || jobRoute || clientRoute) &&
        session.status == SessionStatus.ready) {
      final user = session.session;
      if (user == null) return AppRoutes.login;
      if (clientRoute &&
          (!user.profileComplete || user.role != UserRole.client)) {
        return signedInDestination(session);
      }
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
    if (talent != null) ...[
      GoRoute(
        path: AppRoutes.talentBrowse,
        name: 'talent.browse',
        pageBuilder: (context, state) => _discoveryPage(
          state,
          TalentBrowseView(
            model: talent,
            onHome: () => context.go(AppRoutes.clientHome),
            onInvite: () => context.push(AppRoutes.talentInvite),
            onCompare: () => context.push(AppRoutes.talentCompare),
            onOpen: (id) => context.push(AppRoutes.talentProfile(id)),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.talentCompare,
        name: 'talent.compare',
        pageBuilder: (context, state) => _discoveryPage(
          state,
          TalentCompareView(
            model: talent,
            onBack: () => context.go(AppRoutes.talentBrowse),
            onHome: () => context.go(AppRoutes.clientHome),
            onChoose: (id) => context.push(AppRoutes.talentProfile(id)),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.talentInvite,
        name: 'talent.invite',
        pageBuilder: (context, state) => _discoveryPage(
          state,
          TalentInviteView(
            model: talent,
            onBack: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.talentBrowse);
              }
            },
            onHome: () => context.go(AppRoutes.clientHome),
            onSent: () => context.go(AppRoutes.clientProject),
          ),
        ),
      ),
      GoRoute(
        path: '/talent/profile/:talentId',
        name: 'talent.profile',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          opaque: false,
          barrierDismissible: true,
          barrierLabel: 'Đóng hồ sơ',
          barrierColor: EmeraldColors.primary.withValues(alpha: .24),
          transitionDuration: const Duration(milliseconds: 200),
          child: ListenableBuilder(
            listenable: talent,
            builder: (context, _) {
              final t = talent.find(state.pathParameters['talentId']!);
              if (t == null) return const SizedBox.shrink();
              return TalentQuickProfile(
                talent: t,
                onInvite: () {
                  talent.preselect(t.id);
                  context.push(AppRoutes.talentInvite);
                },
              );
            },
          ),
          transitionsBuilder: (context, animation, secondary, child) =>
              MediaQuery.disableAnimationsOf(context)
              ? child
              : SlideTransition(
                  position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                      .animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                        ),
                      ),
                  child: child,
                ),
        ),
      ),
    ],
    if (projects != null)
      GoRoute(
        path: AppRoutes.clientProject,
        name: 'client.projects.detail',
        pageBuilder: (context, state) => _discoveryPage(
          state,
          ClientProjectView(
            model: projects,
            sentInvites: talent?.sentCount ?? 0,
            onHome: () => context.go(AppRoutes.clientHome),
            onBack: () => context.go(AppRoutes.clientHome),
          ),
        ),
      ),

    if (profile != null) ...[
      GoRoute(
        path: AppRoutes.freelancerProfile,
        name: 'profiles.freelancer',
        pageBuilder: (context, state) => _discoveryPage(
          state,
          FreelancerProfileView(
            model: profile,
            onEdit: () {
              profile.beginEdit();
              context.push(AppRoutes.profileEdit);
            },
            onSkills: () {
              profile.beginEdit();
              context.push(AppRoutes.profileSkills);
            },
            onPortfolio: () => context.push(AppRoutes.portfolio),
            onTab: (index) {
              if (index == 0) context.go(AppRoutes.freelancerHome);
              if (index == 1) context.go(AppRoutes.jobs);
            },
            onShortcut: (key) {
              if (key == 'saved') context.push(AppRoutes.savedJobs);
              if (key == 'proposals') context.push(AppRoutes.myProposals);
            },
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.profileEdit,
        name: 'profiles.edit',
        pageBuilder: (context, state) => _discoveryPage(
          state,
          ProfileEditView(
            model: profile,
            onBack: () => context.go(AppRoutes.freelancerProfile),
            onHome: () => context.go(AppRoutes.freelancerHome),
            onSave: () => context.go(AppRoutes.freelancerProfile),
            onSkills: () => context.push(AppRoutes.profileSkills),
            onPreview: () => context.push(AppRoutes.profilePreview),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.profileSkills,
        name: 'profiles.skills',
        pageBuilder: (context, state) => _discoveryPage(
          state,
          ProfileSkillsView(
            model: profile,
            onBack: () => context.go(AppRoutes.freelancerProfile),
            onHome: () => context.go(AppRoutes.freelancerHome),
            onSave: () => context.go(AppRoutes.freelancerProfile),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.profilePreview,
        name: 'profiles.preview',
        pageBuilder: (context, state) => _discoveryPage(
          state,
          ProfilePreviewView(
            model: profile,
            onBack: () => context.go(AppRoutes.profileEdit),
            onHome: () => context.go(AppRoutes.freelancerHome),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.portfolio,
        name: 'profiles.portfolio',
        pageBuilder: (context, state) => _discoveryPage(
          state,
          PortfolioListView(
            model: profile,
            onBack: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.freelancerProfile);
              }
            },
            onHome: () => context.go(AppRoutes.freelancerHome),
            onPreview: () => context.push(AppRoutes.profilePreview),
            onEdit: (id) {
              profile.editPortfolio(id);
              context.push(AppRoutes.portfolioEdit(id));
            },
          ),
        ),
      ),
      GoRoute(
        path: '/profiles/portfolio/edit/:entryId',
        name: 'profiles.portfolio.edit',
        redirect: (context, state) =>
            profile.portfolioDraft == null ? AppRoutes.portfolio : null,
        pageBuilder: (context, state) => _discoveryPage(
          state,
          PortfolioEditView(
            model: profile,
            onBack: () => context.go(AppRoutes.portfolio),
            onHome: () => context.go(AppRoutes.freelancerHome),
            onSaved: () => context.go(AppRoutes.portfolio),
          ),
        ),
      ),
    ],
    if (discovery != null)
      GoRoute(
        path: AppRoutes.savedJobs,
        name: 'discovery.saved',
        pageBuilder: (context, state) => _discoveryPage(
          state,
          SavedJobsView(
            model: discovery,
            onHome: () => context.go(AppRoutes.freelancerHome),
            onDiscover: () => context.go(AppRoutes.jobs),
            onProfile: () => context.go(AppRoutes.freelancerProfile),
            onJob: (id) => context.push(AppRoutes.project(id)),
          ),
        ),
      ),

    if (projects != null && proposals != null) ...[
      GoRoute(
        path: '/projects/jobs/:jobId',
        name: 'projects.detail',
        redirect: (context, state) =>
            projects.ready &&
                projects.find(state.pathParameters['jobId']!) == null
            ? AppRoutes.jobs
            : null,
        pageBuilder: (context, state) => _discoveryPage(
          state,
          ListenableBuilder(
            listenable: projects,
            builder: (context, _) {
              final p = projects.find(state.pathParameters['jobId']!);
              if (p == null) return const SizedBox.shrink();
              return ProjectDetailView(
                project: p,
                onBack: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.jobs);
                  }
                },
                onHome: () => context.go(AppRoutes.freelancerHome),
                onApply: () => context.push(AppRoutes.vacancies(p.id)),
              );
            },
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.myProposals,
        name: 'proposals.mine',
        pageBuilder: (context, state) => _discoveryPage(
          state,
          MyProposalsView(
            model: proposals,
            onHome: () => context.go(AppRoutes.freelancerHome),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.sentProposals,
        name: 'proposals.sent',
        pageBuilder: (context, state) => _discoveryPage(
          state,
          SentProposalsView(
            model: proposals,
            onHome: () => context.go(AppRoutes.freelancerHome),
            onMine: () => context.go(AppRoutes.myProposals),
          ),
        ),
      ),
      GoRoute(
        path: '/proposals/:jobId/positions',
        name: 'proposals.positions',
        redirect: (context, state) =>
            projects.ready &&
                projects.find(state.pathParameters['jobId']!) == null
            ? AppRoutes.jobs
            : null,
        pageBuilder: (context, state) => _discoveryPage(
          state,
          ListenableBuilder(
            listenable: projects,
            builder: (context, _) {
              final p = projects.find(state.pathParameters['jobId']!);
              if (p == null) return const SizedBox.shrink();
              return VacancySelectionView(
                project: p,
                onBack: () => context.go(AppRoutes.project(p.id)),
                onHome: () => context.go(AppRoutes.freelancerHome),
                onSelect: (v) {
                  proposals.begin(p, v);
                  context.push(AppRoutes.proposal(p.id, ProposalStage.start));
                },
              );
            },
          ),
        ),
      ),
      GoRoute(
        path: '/proposals/:jobId/:stage',
        name: 'proposals.flow',
        redirect: (context, state) {
          final id = state.pathParameters['jobId']!;
          if (proposals.draft?.project.id != id) return AppRoutes.vacancies(id);
          if (!ProposalStage.values.any(
            (s) => s.name == state.pathParameters['stage'],
          )) {
            return AppRoutes.vacancies(id);
          }
          if (state.pathParameters['stage'] == 'success' &&
              proposals.sent?.projectId != id) {
            return AppRoutes.proposal(id, ProposalStage.preview);
          }
          return null;
        },
        pageBuilder: (context, state) {
          final id = state.pathParameters['jobId']!;
          final stage = ProposalStage.values.firstWhere(
            (s) => s.name == state.pathParameters['stage'],
          );
          void go(ProposalStage to) => context.go(AppRoutes.proposal(id, to));
          return _discoveryPage(
            state,
            ProposalFlowView(
              model: proposals,
              stage: stage,
              onBack: () {
                switch (stage) {
                  case ProposalStage.start:
                    context.go(AppRoutes.vacancies(id));
                  case ProposalStage.screening:
                    context.go(AppRoutes.myProposals);
                  case ProposalStage.letter:
                    go(ProposalStage.start);
                  case ProposalStage.quote:
                    go(ProposalStage.letter);
                  case ProposalStage.preview:
                    go(ProposalStage.quote);
                  case ProposalStage.success:
                    context.go(AppRoutes.myProposals);
                }
              },
              onHome: () => context.go(AppRoutes.freelancerHome),
              onMine: () => context.go(AppRoutes.myProposals),
              onEdit: go,
              onPortfolio: profile == null
                  ? null
                  : () => context.push(AppRoutes.portfolio),
              onNext: () async {
                switch (stage) {
                  case ProposalStage.start:
                    go(ProposalStage.screening);
                  case ProposalStage.screening:
                    go(ProposalStage.letter);
                  case ProposalStage.letter:
                    go(ProposalStage.quote);
                  case ProposalStage.quote:
                    go(ProposalStage.preview);
                  case ProposalStage.preview:
                    if (await proposals.submit() && context.mounted) {
                      go(ProposalStage.success);
                    }
                  case ProposalStage.success:
                    context.go(AppRoutes.sentProposals);
                }
              },
            ),
          );
        },
      ),
    ],
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
              onProfile: profile == null
                  ? null
                  : () => context.go(AppRoutes.freelancerProfile),
              onJob: projects == null
                  ? null
                  : (id) => context.push(AppRoutes.project(id)),
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
                onListing: session.session!.role == UserRole.client
                    ? (talent == null
                          ? null
                          : (id) => context.push(AppRoutes.talentProfile(id)))
                    : (projects == null
                          ? null
                          : (id) => context.push(AppRoutes.project(id))),
                onSearch: session.session!.role == UserRole.client
                    ? (talent == null
                          ? null
                          : () => context.push(AppRoutes.talentBrowse))
                    : (discovery == null
                          ? null
                          : () => context.push(AppRoutes.jobSearch)),
                onFilter: session.session!.role == UserRole.client
                    ? (talent == null
                          ? null
                          : () => context.push(AppRoutes.talentBrowse))
                    : (discovery == null
                          ? null
                          : () => context.push(AppRoutes.jobFilter)),
                onExplore: session.session!.role == UserRole.client
                    ? (talent == null
                          ? null
                          : () => context.go(AppRoutes.talentBrowse))
                    : (discovery == null
                          ? null
                          : () => context.go(AppRoutes.jobs)),
                onCategory:
                    discovery == null ||
                        session.session!.role != UserRole.freelancer
                    ? (talent == null
                          ? null
                          : (value) {
                              talent.selectCategory('Tất cả');
                              context.go(AppRoutes.talentBrowse);
                            })
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
                    ? (talent == null
                          ? null
                          : (index) {
                              if (index == 0) context.go(AppRoutes.clientHome);
                              if (index == 2) {
                                context.go(AppRoutes.talentBrowse);
                              }
                            })
                    : (index) {
                        if (index == 0) {
                          context.go(AppRoutes.freelancerHome);
                        } else if (index == 1) {
                          context.go(AppRoutes.jobs);
                        } else if (index == 4 && profile != null) {
                          context.go(AppRoutes.freelancerProfile);
                        }
                      },
              ),
      ),
  ],
  errorBuilder: (_, _) => const Scaffold(body: SizedBox.expand()),
);
