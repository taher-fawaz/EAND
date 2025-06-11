enum AppRoute {
  githubRepos(path: "/github/repos");

  final String path;
  const AppRoute({required this.path});
}
