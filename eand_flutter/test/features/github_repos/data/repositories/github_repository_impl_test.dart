import 'package:eand_flutter/src/core/errors/exceptions.dart';
import 'package:eand_flutter/src/core/errors/failures.dart';
import 'package:eand_flutter/src/core/network/network_checker.dart';
import 'package:eand_flutter/src/features/github_repos/data/datasources/github_local_datasource.dart';
import 'package:eand_flutter/src/features/github_repos/data/datasources/github_remote_datasource.dart';
import 'package:eand_flutter/src/features/github_repos/data/models/github_commit_model.dart';
import 'package:eand_flutter/src/features/github_repos/data/models/github_repo_model.dart';
import 'package:eand_flutter/src/features/github_repos/data/repositories/github_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'github_repository_impl_test.mocks.dart';

@GenerateMocks([GithubRemoteDataSource, GithubLocalDataSource, NetworkInfo])
void main() {
  late GithubRepositoryImpl repository;
  late MockGithubRemoteDataSource mockRemoteDataSource;
  late MockGithubLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockGithubRemoteDataSource();
    mockLocalDataSource = MockGithubLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = GithubRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getRepositories', () {
    final tUsername = 'testuser';
    final tRepoModels = [
      GithubRepoModel(
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

    test('should check if the device is online', () async {
      // arrange
      when(
        mockNetworkInfo.check(
          onConnected: anyNamed('onConnected'),
          onNotConnected: anyNamed('onNotConnected'),
        ),
      ).thenAnswer((_) async => Right(tRepoModels));

      // act
      await repository.getRepositories(tUsername);

      // assert
      verify(
        mockNetworkInfo.check(
          onConnected: anyNamed('onConnected'),
          onNotConnected: anyNamed('onNotConnected'),
        ),
      );
    });

    group('device is online', () {
      setUp(() {
        when(
          mockNetworkInfo.check(
            onConnected: anyNamed('onConnected'),
            onNotConnected: anyNamed('onNotConnected'),
          ),
        ).thenAnswer((invocation) async {
          final onConnected =
              invocation.namedArguments[const Symbol('onConnected')]
                  as Function();
          return await onConnected();
        });
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getRepositories(any),
          ).thenAnswer((_) async => tRepoModels);

          // act
          final result = await repository.getRepositories(tUsername);

          // assert
          verify(mockRemoteDataSource.getRepositories(tUsername));
          verify(mockLocalDataSource.cacheRepositories(tUsername, tRepoModels));
          expect(result, Right(tRepoModels));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getRepositories(any),
          ).thenAnswer((_) async => tRepoModels);

          // act
          await repository.getRepositories(tUsername);

          // assert
          verify(mockRemoteDataSource.getRepositories(tUsername));
          verify(mockLocalDataSource.cacheRepositories(tUsername, tRepoModels));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getRepositories(any),
          ).thenThrow(ServerException());
          when(
            mockLocalDataSource.getRepositories(any),
          ).thenThrow(CacheException());

          // act
          final result = await repository.getRepositories(tUsername);

          // assert
          verify(mockRemoteDataSource.getRepositories(tUsername));
          expect(result, Left(ServerFailure()));
        },
      );

      test(
        'should return last locally cached data when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getRepositories(any),
          ).thenThrow(ServerException());
          when(
            mockLocalDataSource.getRepositories(any),
          ).thenAnswer((_) async => tRepoModels);

          // act
          final result = await repository.getRepositories(tUsername);

          // assert
          verify(mockRemoteDataSource.getRepositories(tUsername));
          verify(mockLocalDataSource.getRepositories(tUsername));
          expect(result, Right(tRepoModels));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(
          mockNetworkInfo.check(
            onConnected: anyNamed('onConnected'),
            onNotConnected: anyNamed('onNotConnected'),
          ),
        ).thenAnswer((invocation) async {
          final onNotConnected =
              invocation.namedArguments[const Symbol('onNotConnected')]
                  as Function();
          return await onNotConnected();
        });
      });

      test(
        'should return locally cached data when the cached data is present',
        () async {
          // arrange
          when(
            mockLocalDataSource.getRepositories(any),
          ).thenAnswer((_) async => tRepoModels);

          // act
          final result = await repository.getRepositories(tUsername);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getRepositories(tUsername));
          expect(result, Right(tRepoModels));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(
            mockLocalDataSource.getRepositories(any),
          ).thenThrow(CacheException());

          // act
          final result = await repository.getRepositories(tUsername);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getRepositories(tUsername));
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getCommits', () {
    final tOwner = 'testuser';
    final tRepo = 'repo1';
    final tCommitModels = [
      GithubCommitModel(
        sha: 'abc123',
        message: 'Test commit',
        authorName: 'Test Author',
        authorEmail: 'test@example.com',
        date: '2023-06-01',
        url: 'https://github.com/avatar.png',
      ),
    ];

    test('should check if the device is online', () async {
      // arrange
      when(
        mockNetworkInfo.check(
          onConnected: anyNamed('onConnected'),
          onNotConnected: anyNamed('onNotConnected'),
        ),
      ).thenAnswer((_) async => Right(tCommitModels));

      // act
      await repository.getCommits(tOwner, tRepo);

      // assert
      verify(
        mockNetworkInfo.check(
          onConnected: anyNamed('onConnected'),
          onNotConnected: anyNamed('onNotConnected'),
        ),
      );
    });

    group('device is online', () {
      setUp(() {
        when(
          mockNetworkInfo.check(
            onConnected: anyNamed('onConnected'),
            onNotConnected: anyNamed('onNotConnected'),
          ),
        ).thenAnswer((invocation) async {
          final onConnected =
              invocation.namedArguments[const Symbol('onConnected')]
                  as Function();
          return await onConnected();
        });
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getCommits(
              any,
              any,
              perPage: anyNamed('perPage'),
            ),
          ).thenAnswer((_) async => tCommitModels);

          // act
          final result = await repository.getCommits(tOwner, tRepo);

          // assert
          verify(mockRemoteDataSource.getCommits(tOwner, tRepo, perPage: 3));
          verify(
            mockLocalDataSource.cacheCommits(tOwner, tRepo, tCommitModels),
          );
          expect(result, Right(tCommitModels));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getCommits(
              any,
              any,
              perPage: anyNamed('perPage'),
            ),
          ).thenAnswer((_) async => tCommitModels);

          // act
          await repository.getCommits(tOwner, tRepo);

          // assert
          verify(mockRemoteDataSource.getCommits(tOwner, tRepo, perPage: 3));
          verify(
            mockLocalDataSource.cacheCommits(tOwner, tRepo, tCommitModels),
          );
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getCommits(
              any,
              any,
              perPage: anyNamed('perPage'),
            ),
          ).thenThrow(ServerException());
          when(
            mockLocalDataSource.getCommits(
              any,
              any,
              perPage: anyNamed('perPage'),
            ),
          ).thenThrow(CacheException());

          // act
          final result = await repository.getCommits(tOwner, tRepo);

          // assert
          verify(mockRemoteDataSource.getCommits(tOwner, tRepo, perPage: 3));
          expect(result, Left(ServerFailure()));
        },
      );

      test(
        'should return last locally cached data when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getCommits(
              any,
              any,
              perPage: anyNamed('perPage'),
            ),
          ).thenThrow(ServerException());
          when(
            mockLocalDataSource.getCommits(
              any,
              any,
              perPage: anyNamed('perPage'),
            ),
          ).thenAnswer((_) async => tCommitModels);

          // act
          final result = await repository.getCommits(tOwner, tRepo);

          // assert
          verify(mockRemoteDataSource.getCommits(tOwner, tRepo, perPage: 3));
          verify(mockLocalDataSource.getCommits(tOwner, tRepo, perPage: 3));
          expect(result, Right(tCommitModels));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(
          mockNetworkInfo.check(
            onConnected: anyNamed('onConnected'),
            onNotConnected: anyNamed('onNotConnected'),
          ),
        ).thenAnswer((invocation) async {
          final onNotConnected =
              invocation.namedArguments[const Symbol('onNotConnected')]
                  as Function();
          return await onNotConnected();
        });
      });

      test(
        'should return locally cached data when the cached data is present',
        () async {
          // arrange
          when(
            mockLocalDataSource.getCommits(
              any,
              any,
              perPage: anyNamed('perPage'),
            ),
          ).thenAnswer((_) async => tCommitModels);

          // act
          final result = await repository.getCommits(tOwner, tRepo);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getCommits(tOwner, tRepo, perPage: 3));
          expect(result, Right(tCommitModels));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(
            mockLocalDataSource.getCommits(
              any,
              any,
              perPage: anyNamed('perPage'),
            ),
          ).thenThrow(CacheException());

          // act
          final result = await repository.getCommits(tOwner, tRepo);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getCommits(tOwner, tRepo, perPage: 3));
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
