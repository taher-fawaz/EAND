import 'package:eand_flutter/src/core/errors/failures.dart';
import 'package:eand_flutter/src/features/github_repos/domain/entities/github_repo_entity.dart';
import 'package:eand_flutter/src/features/github_repos/domain/repositories/github_repository.dart';
import 'package:eand_flutter/src/features/github_repos/domain/usecases/get_repositories_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_repositories_usecase_test.mocks.dart';

@GenerateMocks([GithubRepository])
void main() {
  late GetRepositoriesUseCase usecase;
  late MockGithubRepository mockRepository;

  setUp(() {
    mockRepository = MockGithubRepository();
    usecase = GetRepositoriesUseCase(mockRepository);
  });

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

  test('should get repositories from the repository', () async {
    // arrange
    when(
      mockRepository.getRepositories(
        any,
        forceRefresh: anyNamed('forceRefresh'),
      ),
    ).thenAnswer((_) async => Right(tRepositories));

    // act
    final result = await usecase(GetRepositoriesParams(username: tUsername));

    // assert
    expect(result, Right(tRepositories));
    verify(mockRepository.getRepositories(tUsername, forceRefresh: false));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should pass forceRefresh parameter to repository', () async {
    // arrange
    when(
      mockRepository.getRepositories(
        any,
        forceRefresh: anyNamed('forceRefresh'),
      ),
    ).thenAnswer((_) async => Right(tRepositories));

    // act
    final result = await usecase(
      GetRepositoriesParams(username: tUsername, forceRefresh: true),
    );

    // assert
    expect(result, Right(tRepositories));
    verify(mockRepository.getRepositories(tUsername, forceRefresh: true));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // arrange
    when(
      mockRepository.getRepositories(
        any,
        forceRefresh: anyNamed('forceRefresh'),
      ),
    ).thenAnswer((_) async => Left(ServerFailure()));

    // act
    final result = await usecase(GetRepositoriesParams(username: tUsername));

    // assert
    expect(result, Left(ServerFailure()));
    verify(mockRepository.getRepositories(tUsername, forceRefresh: false));
    verifyNoMoreInteractions(mockRepository);
  });
}
