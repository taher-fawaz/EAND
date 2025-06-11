import 'package:equatable/equatable.dart';

import '../../domain/entities/github_commit_entity.dart';
import '../../domain/entities/github_repo_entity.dart';

enum GithubRepoStatus {
  initial,
  loading,
  refreshing,
  success,
  failure,
}

class GithubRepoState extends Equatable {
  final List<GithubRepoEntity> repositories;
  final List<GithubCommitEntity> commits;
  final GithubRepoStatus status;
  final GithubRepoStatus commitsStatus;
  final String errorMessage;
  final bool isDetailOpen;
  final int selectedRepoIndex;

  const GithubRepoState({
    this.repositories = const [],
    this.commits = const [],
    this.status = GithubRepoStatus.initial,
    this.commitsStatus = GithubRepoStatus.initial,
    this.errorMessage = '',
    this.isDetailOpen = false,
    this.selectedRepoIndex = -1,
  });

  GithubRepoEntity? get selectedRepository {
    if (selectedRepoIndex >= 0 && selectedRepoIndex < repositories.length) {
      return repositories[selectedRepoIndex];
    }
    return null;
  }

  List<GithubRepoEntity> get horizontalRepos {
    if (repositories.length <= 5) return repositories;
    return repositories.sublist(0, 5);
  }

  List<GithubRepoEntity> get verticalRepos {
    if (repositories.length <= 5) return [];
    return repositories.sublist(5);
  }

  GithubRepoState copyWith({
    List<GithubRepoEntity>? repositories,
    List<GithubCommitEntity>? commits,
    GithubRepoStatus? status,
    GithubRepoStatus? commitsStatus,
    String? errorMessage,
    bool? isDetailOpen,
    int? selectedRepoIndex,
  }) {
    return GithubRepoState(
      repositories: repositories ?? this.repositories,
      commits: commits ?? this.commits,
      status: status ?? this.status,
      commitsStatus: commitsStatus ?? this.commitsStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isDetailOpen: isDetailOpen ?? this.isDetailOpen,
      selectedRepoIndex: selectedRepoIndex ?? this.selectedRepoIndex,
    );
  }

  @override
  List<Object?> get props => [
        repositories,
        commits,
        status,
        commitsStatus,
        errorMessage,
        isDetailOpen,
        selectedRepoIndex,
      ];
}