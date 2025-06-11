import 'package:equatable/equatable.dart';

abstract class GithubRepoEvent extends Equatable {
  const GithubRepoEvent();

  @override
  List<Object?> get props => [];
}

class FetchRepositories extends GithubRepoEvent {
  final String username;
  final bool forceRefresh;

  const FetchRepositories({
    required this.username,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [username, forceRefresh];
}

class RefreshRepositories extends GithubRepoEvent {
  final String username;

  const RefreshRepositories({required this.username});

  @override
  List<Object?> get props => [username];
}

class FetchCommits extends GithubRepoEvent {
  final String owner;
  final String repo;
  final int perPage;
  final bool forceRefresh;

  const FetchCommits({
    required this.owner,
    required this.repo,
    this.perPage = 3,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [owner, repo, perPage, forceRefresh];
}

class SelectRepository extends GithubRepoEvent {
  final int index;

  const SelectRepository({required this.index});

  @override
  List<Object?> get props => [index];
}

class CloseRepositoryDetails extends GithubRepoEvent {}