import 'package:eand_flutter/src/core/errors/failures.dart';
import 'package:eand_flutter/src/features/github_repos/domain/entities/github_commit_entity.dart';
import 'package:eand_flutter/src/features/github_repos/domain/repositories/github_repository.dart';
import 'package:eand_flutter/src/features/github_repos/domain/usecases/get_commits_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_commits_usecase_test.mocks.dart';

@GenerateMocks([GithubRepository])
void main() {
  late GetCommitsUseCase usecase;
  late MockGithubRepository mockRepository;

  setUp(() {
    mockRepository = MockGithubRepository();
    usecase = GetCommitsUseCase(mockRepository);
  });

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

  test('should get commits from the repository', () async {
    // arrange
    when(
      mockRepository.getCommits(
        any,
        any,
        perPage: anyNamed('perPage'),
        forceRefresh: anyNamed('forceRefresh'),
      ),
    ).thenAnswer((_) async => Right(tCommits));

    // act
    final result = await usecase(GetCommitsParams(owner: tOwner, repo: tRepo));

    // assert
    expect(result, Right(tCommits));
    verify(
      mockRepository.getCommits(tOwner, tRepo, perPage: 3, forceRefresh: false),
    );
    verifyNoMoreInteractions(mockRepository);
  });

  test(
    'should pass perPage and forceRefresh parameters to repository',
    () async {
      // arrange
      when(
        mockRepository.getCommits(
          any,
          any,
          perPage: anyNamed('perPage'),
          forceRefresh: anyNamed('forceRefresh'),
        ),
      ).thenAnswer((_) async => Right(tCommits));

      // act
      final result = await usecase(
        GetCommitsParams(
          owner: tOwner,
          repo: tRepo,
          perPage: 5,
          forceRefresh: true,
        ),
      );

      // assert
      expect(result, Right(tCommits));
      verify(
        mockRepository.getCommits(
          tOwner,
          tRepo,
          perPage: 5,
          forceRefresh: true,
        ),
      );
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return ServerFailure when repository fails', () async {
    // arrange
    when(
      mockRepository.getCommits(
        any,
        any,
        perPage: anyNamed('perPage'),
        forceRefresh: anyNamed('forceRefresh'),
      ),
    ).thenAnswer((_) async => Left(ServerFailure()));

    // act
    final result = await usecase(GetCommitsParams(owner: tOwner, repo: tRepo));

    // assert
    expect(result, Left(ServerFailure()));
    verify(
      mockRepository.getCommits(tOwner, tRepo, perPage: 3, forceRefresh: false),
    );
    verifyNoMoreInteractions(mockRepository);
  });
}
