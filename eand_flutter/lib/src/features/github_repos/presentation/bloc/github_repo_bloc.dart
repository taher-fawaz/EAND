import 'package:eand_flutter/src/features/github_repos/domain/entities/github_commit_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/github_commit_entity.dart';
import '../../domain/entities/github_repo_entity.dart';
import '../../domain/usecases/get_commits_usecase.dart';
import '../../domain/usecases/get_repositories_usecase.dart';
import 'github_repo_event.dart';
import 'github_repo_state.dart';

class GithubRepoBloc extends Bloc<GithubRepoEvent, GithubRepoState> {
  final GetRepositoriesUseCase getRepositoriesUseCase;
  final GetCommitsUseCase getCommitsUseCase;

  GithubRepoBloc({
    required this.getRepositoriesUseCase,
    required this.getCommitsUseCase,
  }) : super(const GithubRepoState()) {
    on<FetchRepositories>(_onFetchRepositories);
    on<RefreshRepositories>(_onRefreshRepositories);
    on<FetchCommits>(_onFetchCommits);
    on<SelectRepository>(_onSelectRepository);
    on<CloseRepositoryDetails>(_onCloseRepositoryDetails);
  }

  Future<void> _onFetchRepositories(
    FetchRepositories event,
    Emitter<GithubRepoState> emit,
  ) async {
    if (state.status == GithubRepoStatus.loading) return;

    emit(
      state.copyWith(
        status: GithubRepoStatus.loading,
        repositories: const [], // Clear repositories when loading
      ),
    );

    final result = await getRepositoriesUseCase(
      GetRepositoriesParams(
        username: event.username,
        forceRefresh: event.forceRefresh,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: GithubRepoStatus.failure,
          errorMessage: 'Failed to load repositories',
          repositories: const [], // Ensure repositories remain empty on failure
        ),
      ),
      (repositories) => emit(
        state.copyWith(
          status: GithubRepoStatus.success,
          repositories: repositories,
        ),
      ),
    );
  }

  Future<void> _onRefreshRepositories(
    RefreshRepositories event,
    Emitter<GithubRepoState> emit,
  ) async {
    emit(
      state.copyWith(
        status: GithubRepoStatus.refreshing,
        repositories: const [], // Clear repositories when refreshing
      ),
    );

    final result = await getRepositoriesUseCase(
      GetRepositoriesParams(username: event.username, forceRefresh: true),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: GithubRepoStatus.failure,
          errorMessage: 'Failed to refresh repositories',
          repositories: const [], // Ensure repositories remain empty on failure
        ),
      ),
      (repositories) => emit(
        state.copyWith(
          status: GithubRepoStatus.success,
          repositories: repositories,
        ),
      ),
    );
  }

  Future<void> _onFetchCommits(
    FetchCommits event,
    Emitter<GithubRepoState> emit,
  ) async {
    // If we already have commits for this repo, don't fetch again
    if (state.commits.isNotEmpty && !event.forceRefresh) return;

    // Emit loading state with empty commits list
    emit(
      state.copyWith(
        commitsStatus: GithubRepoStatus.loading,
        commits: const [], // Always clear commits when loading
      ),
    );

    final result = await getCommitsUseCase(
      GetCommitsParams(
        owner: event.owner,
        repo: event.repo,
        perPage: event.perPage,
        forceRefresh: event.forceRefresh,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          commitsStatus: GithubRepoStatus.failure,
          errorMessage: 'Failed to load commits',
          commits: const [], // Clear commits on failure
        ),
      ),
      (commits) => emit(
        state.copyWith(
          commitsStatus: GithubRepoStatus.success,
          commits: commits,
        ),
      ),
    );
  }

  void _onSelectRepository(
    SelectRepository event,
    Emitter<GithubRepoState> emit,
  ) {
    if (state.repositories.isEmpty ||
        event.index >= state.repositories.length) {
      return;
    }

    final selectedRepo = state.repositories[event.index];

    emit(state.copyWith(selectedRepoIndex: event.index, isDetailOpen: true));
  }

  void _onCloseRepositoryDetails(
    CloseRepositoryDetails event,
    Emitter<GithubRepoState> emit,
  ) {
    emit(
      state.copyWith(
        isDetailOpen: false,
        commits: const [],
        commitsStatus: GithubRepoStatus.initial,
      ),
    );
  }
}
