class GithubApiUrls {
  const GithubApiUrls._();

  static const baseUrl = 'https://api.github.com';
  
  // Get repositories for a user
  static String userRepos(String username) => '$baseUrl/users/$username/repos';
  
  // Get commits for a repository
  static String repoCommits(String owner, String repo) => '$baseUrl/repos/$owner/$repo/commits';
}