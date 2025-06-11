import 'package:bloc_test/bloc_test.dart';
import 'package:eand_flutter/src/core/errors/failures.dart';
import 'package:eand_flutter/src/features/github_repos/domain/entities/github_commit_entity.dart';
import 'package:eand_flutter/src/features/github_repos/domain/entities/github_repo_entity.dart';
import 'package:eand_flutter/src/features/github_repos/domain/usecases/get_commits_usecase.dart';
import 'package:eand_flutter/src/features/github_repos/domain/usecases/get_repositories_usecase.dart';
import 'package:eand_flutter/src/features/github_repos/presentation/bloc/github_repo_bloc.dart';
import 'package:eand_flutter/src/features/github_repos/presentation/bloc/github_repo_event.dart';
import 'package:eand_flutter/src/features/github_repos/presentation/bloc/github_repo_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'github_repo_bloc_test.mocks.dart';

@GenerateMocks([GetRepositoriesUseCase, GetCommitsUseCase])
void main() {
  late GithubRepoBloc bloc;
  late MockGetRepositoriesUseCase mockGetRepositoriesUseCase;
  late MockGetCommitsUseCase mockGetCommitsUseCase;

  setUp(() {
    mockGetRepositoriesUseCase = MockGetRepositoriesUseCase();
    mockGetCommitsUseCase = MockGetCommitsUseCase();
    bloc = GithubRepoBloc(
      getRepositoriesUseCase: mockGetRepositoriesUseCase,
      getCommitsUseCase: mockGetCommitsUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be correct', () {
    expect(bloc.state, const GithubRepoState());
  });

  group('FetchRepositories', () {
    final tUsername = 'testuser';
    final tRepositories = [
      GithubRepoEntity(
        id: 1,
        name: 'repo1',
        fullName: 'testuser/repo1',
        private: false,
        htmlUrl: 'https://github.com/testuser/repo1',
        stargazersCount: 10,
        watchersCount: 5,
        forksCount: 2,
        createdAt: '2023-01-01',
        updatedAt: '2023-06-01',
      ),
      GithubRepoEntity(
        id: 2,
        name: 'repo2',
        fullName: 'testuser/repo2',
        private: false,
        htmlUrl: 'https://github.com/testuser/repo2',
        stargazersCount: 20,
        watchersCount: 8,
        forksCount: 5,
        createdAt: '2023-02-01',
        updatedAt: '2023-07-01',
      ),
    ];

    test(
      'should emit loading and success states when data is fetched successfully',
      () async {
        // Arrange
        when(
          mockGetRepositoriesUseCase(any),
        ).thenAnswer((_) async => Right(tRepositories));

        // Set initial state
        bloc = GithubRepoBloc(
          getRepositoriesUseCase: mockGetRepositoriesUseCase,
          getCommitsUseCase: mockGetCommitsUseCase,
        );

        // Act
        bloc.add(FetchRepositories(username: tUsername));

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<GithubRepoState>()
                .having((s) => s.status, 'status', GithubRepoStatus.loading)
                .having((s) => s.repositories, 'repositories', isEmpty),
            isA<GithubRepoState>()
                .having((s) => s.status, 'status', GithubRepoStatus.success)
                .having((s) => s.repositories, 'repositories', tRepositories),
          ]),
        );

        // Verify
        verify(mockGetRepositoriesUseCase(any)).called(1);
      },
    );

    test(
      'should emit loading and failure states when getting data fails',
      () async {
        // Arrange
        when(
          mockGetRepositoriesUseCase(any),
        ).thenAnswer((_) async => Left(ServerFailure()));

        // Set initial state
        bloc = GithubRepoBloc(
          getRepositoriesUseCase: mockGetRepositoriesUseCase,
          getCommitsUseCase: mockGetCommitsUseCase,
        );

        // Act
        bloc.add(FetchRepositories(username: tUsername));

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<GithubRepoState>()
                .having((s) => s.status, 'status', GithubRepoStatus.loading)
                .having((s) => s.repositories, 'repositories', isEmpty),
            isA<GithubRepoState>()
                .having((s) => s.status, 'status', GithubRepoStatus.failure)
                .having(
                  (s) => s.errorMessage,
                  'errorMessage',
                  'Failed to load repositories',
                )
                .having((s) => s.repositories, 'repositories', isEmpty),
          ]),
        );

        // Verify
        verify(mockGetRepositoriesUseCase(any)).called(1);
      },
    );
  });

  group('RefreshRepositories', () {
    final tUsername = 'testuser';
    final tRepositories = [
      GithubRepoEntity(
        id: 1,
        name: 'repo1',
        fullName: 'testuser/repo1',
        private: false,
        htmlUrl: 'https://github.com/testuser/repo1',
        stargazersCount: 10,
        watchersCount: 5,
        forksCount: 2,
        createdAt: '2023-01-01',
        updatedAt: '2023-06-01',
      ),
    ];

    test(
      'should emit refreshing and success states when refresh is successful',
      () async {
        // Arrange
        when(
          mockGetRepositoriesUseCase(any),
        ).thenAnswer((_) async => Right(tRepositories));

        // Set initial state
        bloc = GithubRepoBloc(
          getRepositoriesUseCase: mockGetRepositoriesUseCase,
          getCommitsUseCase: mockGetCommitsUseCase,
        );

        // Act
        bloc.add(RefreshRepositories(username: tUsername));

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<GithubRepoState>()
                .having((s) => s.status, 'status', GithubRepoStatus.refreshing)
                .having((s) => s.repositories, 'repositories', isEmpty),
            isA<GithubRepoState>()
                .having((s) => s.status, 'status', GithubRepoStatus.success)
                .having((s) => s.repositories, 'repositories', tRepositories),
          ]),
        );

        // Verify
        verify(mockGetRepositoriesUseCase(any)).called(1);
      },
    );

    test(
      'should emit refreshing and failure states when refresh fails',
      () async {
        // Arrange
        when(
          mockGetRepositoriesUseCase(any),
        ).thenAnswer((_) async => Left(ServerFailure()));

        // Set initial state
        bloc = GithubRepoBloc(
          getRepositoriesUseCase: mockGetRepositoriesUseCase,
          getCommitsUseCase: mockGetCommitsUseCase,
        );

        // Act
        bloc.add(RefreshRepositories(username: tUsername));

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<GithubRepoState>()
                .having((s) => s.status, 'status', GithubRepoStatus.refreshing)
                .having((s) => s.repositories, 'repositories', isEmpty),
            isA<GithubRepoState>()
                .having((s) => s.status, 'status', GithubRepoStatus.failure)
                .having(
                  (s) => s.errorMessage,
                  'errorMessage',
                  'Failed to refresh repositories',
                )
                .having((s) => s.repositories, 'repositories', isEmpty),
          ]),
        );

        // Verify
        verify(mockGetRepositoriesUseCase(any)).called(1);
      },
    );
  });

  group('FetchCommits', () {
    final tOwner = 'testuser';
    final tRepo = 'repo1';
    final tCommits = [
      GithubCommitEntity(
        sha: 'abc123',
        message: 'Test commit',
        authorName: 'Test Author',
        authorEmail: 'test@example.com',
        date: '2023-06-01',
        url: 'https://github.com/avatar.png',
      ),
    ];

    test(
      'should emit loading and success states when commits are fetched successfully',
      () async {
        // Arrange
        when(
          mockGetCommitsUseCase(any),
        ).thenAnswer((_) async => Right(tCommits));

        // Set initial state
        bloc = GithubRepoBloc(
          getRepositoriesUseCase: mockGetRepositoriesUseCase,
          getCommitsUseCase: mockGetCommitsUseCase,
        );

        // Act
        bloc.add(FetchCommits(owner: tOwner, repo: tRepo, forceRefresh: true));

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<GithubRepoState>()
                .having(
                  (s) => s.commitsStatus,
                  'commitsStatus',
                  GithubRepoStatus.loading,
                )
                .having((s) => s.commits, 'commits', isEmpty),
            isA<GithubRepoState>()
                .having(
                  (s) => s.commitsStatus,
                  'commitsStatus',
                  GithubRepoStatus.success,
                )
                .having((s) => s.commits, 'commits', tCommits),
          ]),
        );

        // Verify
        verify(mockGetCommitsUseCase(any)).called(1);
      },
    );

    test(
      'should emit loading and failure states when getting commits fails',
      () async {
        // Arrange
        when(
          mockGetCommitsUseCase(any),
        ).thenAnswer((_) async => Left(ServerFailure()));

        // Set initial state
        bloc = GithubRepoBloc(
          getRepositoriesUseCase: mockGetRepositoriesUseCase,
          getCommitsUseCase: mockGetCommitsUseCase,
        );

        // Act
        bloc.add(FetchCommits(owner: tOwner, repo: tRepo, forceRefresh: true));

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<GithubRepoState>()
                .having(
                  (s) => s.commitsStatus,
                  'commitsStatus',
                  GithubRepoStatus.loading,
                )
                .having((s) => s.commits, 'commits', isEmpty),
            isA<GithubRepoState>()
                .having(
                  (s) => s.commitsStatus,
                  'commitsStatus',
                  GithubRepoStatus.failure,
                )
                .having(
                  (s) => s.errorMessage,
                  'errorMessage',
                  'Failed to load commits',
                )
                .having((s) => s.commits, 'commits', isEmpty),
          ]),
        );

        // Verify
        verify(mockGetCommitsUseCase(any)).called(1);
      },
    );
  });

  group('SelectRepository', () {
    final tRepositories = [
      GithubRepoEntity(
        id: 1,
        name: 'repo1',
        fullName: 'testuser/repo1',
        private: false,
        htmlUrl: 'https://github.com/testuser/repo1',
        stargazersCount: 10,
        watchersCount: 5,
        forksCount: 2,
        createdAt: '2023-01-01',
        updatedAt: '2023-06-01',
      ),
      GithubRepoEntity(
        id: 2,
        name: 'repo2',
        fullName: 'testuser/repo2',
        private: false,
        htmlUrl: 'https://github.com/testuser/repo2',
        stargazersCount: 20,
        watchersCount: 8,
        forksCount: 5,
        createdAt: '2023-02-01',
        updatedAt: '2023-07-01',
      ),
      GithubRepoEntity(
        id: 3,
        name: 'repo3',
        fullName: 'testuser/repo3',
        private: false,
        htmlUrl: 'https://github.com/testuser/repo3',
        stargazersCount: 30,
        watchersCount: 12,
        forksCount: 8,
        createdAt: '2023-03-01',
        updatedAt: '2023-08-01',
      ),
    ];

    test('should update selectedRepoIndex and isDetailOpen', () async {
      // Arrange
      bloc = GithubRepoBloc(
        getRepositoriesUseCase: mockGetRepositoriesUseCase,
        getCommitsUseCase: mockGetCommitsUseCase,
      );

      // Set initial state with repositories
      bloc.emit(GithubRepoState(repositories: tRepositories));

      // Act
      bloc.add(const SelectRepository(index: 2));

      // Assert
      await expectLater(
        bloc.stream,
        emits(
          isA<GithubRepoState>()
              .having((s) => s.repositories, 'repositories', tRepositories)
              .having((s) => s.selectedRepoIndex, 'selectedRepoIndex', 2)
              .having((s) => s.isDetailOpen, 'isDetailOpen', true),
        ),
      );
    });
  });

  group('CloseRepositoryDetails', () {
    final tRepositories = [
      GithubRepoEntity(
        id: 1,
        name: 'repo1',
        fullName: 'testuser/repo1',
        private: false,
        htmlUrl: 'https://github.com/testuser/repo1',
        stargazersCount: 10,
        watchersCount: 5,
        forksCount: 2,
        createdAt: '2023-01-01',
        updatedAt: '2023-06-01',
      ),
      GithubRepoEntity(
        id: 2,
        name: 'repo2',
        fullName: 'testuser/repo2',
        private: false,
        htmlUrl: 'https://github.com/testuser/repo2',
        stargazersCount: 20,
        watchersCount: 8,
        forksCount: 5,
        createdAt: '2023-02-01',
        updatedAt: '2023-07-01',
      ),
    ];

    final tCommits = [
      GithubCommitEntity(
        sha: 'sha1',
        message: 'commit 1',
        authorName: 'Author 1',
        authorEmail: 'author1@example.com',
        date: '2023-01-01',
        url: 'URL_ADDRESS.com/avatar.png',
      ),
    ];

    test('should set isDetailOpen to false and reset commits', () async {
      // Arrange
      bloc = GithubRepoBloc(
        getRepositoriesUseCase: mockGetRepositoriesUseCase,
        getCommitsUseCase: mockGetCommitsUseCase,
      );

      // Set initial state with repositories, commits, and open details
      bloc.emit(
        GithubRepoState(
          repositories: tRepositories,
          commits: tCommits,
          isDetailOpen: true,
          selectedRepoIndex: 1,
          commitsStatus: GithubRepoStatus.success,
        ),
      );

      // Act
      bloc.add(CloseRepositoryDetails());

      // Assert
      await expectLater(
        bloc.stream,
        emits(
          isA<GithubRepoState>()
              .having((s) => s.repositories, 'repositories', tRepositories)
              .having((s) => s.commits, 'commits', isEmpty)
              .having((s) => s.isDetailOpen, 'isDetailOpen', false)
              .having((s) => s.selectedRepoIndex, 'selectedRepoIndex', 1)
              .having(
                (s) => s.commitsStatus,
                'commitsStatus',
                GithubRepoStatus.initial,
              ),
        ),
      );
    });
  });
}
