import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/github_repos/presentation/screens/github_repo_list_screen.dart';
import 'app_route_path.dart';
import 'routes.dart';

class AppRouteConf {
  GoRouter get router => _router;

  late final _router = GoRouter(
    initialLocation: AppRoute.githubRepos.path,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoute.githubRepos.path,
        builder: (context, state) => const GithubRepoListScreen(),
      ),
    ],
  );
}
