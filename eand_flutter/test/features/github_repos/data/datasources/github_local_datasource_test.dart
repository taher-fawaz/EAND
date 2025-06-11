import 'dart:convert';

import 'package:eand_flutter/src/core/cache/local_storage.dart';
import 'package:eand_flutter/src/core/errors/exceptions.dart';
import 'package:eand_flutter/src/features/github_repos/data/datasources/github_local_datasource.dart';
import 'package:eand_flutter/src/features/github_repos/data/models/github_commit_model.dart';
import 'package:eand_flutter/src/features/github_repos/data/models/github_repo_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'github_local_datasource_test.mocks.dart';

@GenerateMocks([LocalStorage])
void main() {
  late GithubLocalDataSourceImpl dataSource;
  late MockLocalStorage mockLocalStorage;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    dataSource = GithubLocalDataSourceImpl(localStorage: mockLocalStorage);
  });

  group('getRepositories', () {
    final tUsername = 'testuser';
    final tReposJsonString = fixture('github_repos.json');
    final tReposJson = json.decode(tReposJsonString) as List;
    final tRepoModels = tReposJson
        .map((repoJson) => GithubRepoModel.fromJson(repoJson))
        .toList();

    test('should return cached repositories when they exist', () async {
      // arrange
      when(
        mockLocalStorage.load(
          key: anyNamed('key'),
          boxName: anyNamed('boxName'),
        ),
      ).thenAnswer((_) async => tReposJsonString);

      // act
      final result = await dataSource.getRepositories(tUsername);

      // assert
      verify(mockLocalStorage.load(key: tUsername, boxName: 'github_repos'));
      expect(result, equals(tRepoModels));
    });

    test('should throw CacheException when there is no cached data', () async {
      // arrange
      when(
        mockLocalStorage.load(
          key: anyNamed('key'),
          boxName: anyNamed('boxName'),
        ),
      ).thenAnswer((_) async => null);

      // act
      final call = dataSource.getRepositories;

      // assert
      expect(() => call(tUsername), throwsA(isA<CacheException>()));
    });

    test('should cache repositories', () async {
      // act
      await dataSource.cacheRepositories(tUsername, tRepoModels);

      // assert
      final jsonString = json.encode(
        tRepoModels.map((e) => e.toJson()).toList(),
      );
      verify(
        mockLocalStorage.save(
          key: tUsername,
          value: jsonString,
          boxName: 'github_repos',
        ),
      );
    });
  });

  group('getCommits', () {
    final tOwner = 'testuser';
    final tRepo = 'repo1';
    final tCommitsJsonString = fixture('github_commits.json');
    final tCommitsJson = json.decode(tCommitsJsonString) as List;
    final tCommitModels = tCommitsJson
        .map((commitJson) => GithubCommitModel.fromJson(commitJson))
        .toList();
    final tCacheKey = '${tOwner}_$tRepo';

    test('should return cached commits when they exist', () async {
      // arrange
      when(
        mockLocalStorage.load(
          key: anyNamed('key'),
          boxName: anyNamed('boxName'),
        ),
      ).thenAnswer((_) async => tCommitsJsonString);

      // act
      final result = await dataSource.getCommits(tOwner, tRepo);

      // assert
      verify(mockLocalStorage.load(key: tCacheKey, boxName: 'github_commits'));
      expect(result, equals(tCommitModels));
    });

    test('should throw CacheException when there is no cached data', () async {
      // arrange
      when(
        mockLocalStorage.load(
          key: anyNamed('key'),
          boxName: anyNamed('boxName'),
        ),
      ).thenAnswer((_) async => null);

      // act
      final call = dataSource.getCommits;

      // assert
      expect(() => call(tOwner, tRepo), throwsA(isA<CacheException>()));
    });

    test('should cache commits', () async {
      // act
      await dataSource.cacheCommits(tOwner, tRepo, tCommitModels);

      // assert
      final jsonString = json.encode(
        tCommitModels.map((e) => e.toJson()).toList(),
      );
      verify(
        mockLocalStorage.save(
          key: tCacheKey,
          value: jsonString,
          boxName: 'github_commits',
        ),
      );
    });
  });
}
