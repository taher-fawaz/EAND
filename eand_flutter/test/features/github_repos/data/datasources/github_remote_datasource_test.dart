import 'dart:convert';

import 'package:eand_flutter/src/core/errors/exceptions.dart';
import 'package:eand_flutter/src/core/api/api_helper.dart';
import 'package:eand_flutter/src/features/github_repos/data/datasources/github_remote_datasource.dart';
import 'package:eand_flutter/src/features/github_repos/data/models/github_commit_model.dart';
import 'package:eand_flutter/src/features/github_repos/data/models/github_repo_model.dart';
import 'package:eand_flutter/src/features/github_repos/data/datasources/github_api_urls.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'github_remote_datasource_test.mocks.dart';

@GenerateMocks([ApiHelper])
void main() {
  late GithubRemoteDataSourceImpl dataSource;
  late MockApiHelper mockApiHelper;

  setUp(() {
    mockApiHelper = MockApiHelper();
    dataSource = GithubRemoteDataSourceImpl(apiHelper: mockApiHelper);
  });

  group('getRepositories', () {
    final tUsername = 'testuser';
    final tReposJsonString = fixture('github_repos.json');
    final tReposJson = json.decode(tReposJsonString) as List;
    final tRepoModels = tReposJson
        .map((repoJson) => GithubRepoModel.fromJson(repoJson))
        .toList();

    test(
      'should perform a GET request with username in the endpoint',
      () async {
        // arrange
        when(
          mockApiHelper.execute(
            method: anyNamed('method'),
            url: anyNamed('url'),
          ),
        ).thenAnswer((_) async => json.decode(tReposJsonString));

        // act
        await dataSource.getRepositories(tUsername);

        // assert
        verify(
          mockApiHelper.execute(
            method: Method.get,
            url: GithubApiUrls.userRepos(tUsername),
          ),
        );
      },
    );

    test(
      'should return List<GithubRepoModel> when the response is successful',
      () async {
        // arrange
        when(
          mockApiHelper.execute(
            method: anyNamed('method'),
            url: anyNamed('url'),
          ),
        ).thenAnswer((_) async => json.decode(tReposJsonString));

        // act
        final result = await dataSource.getRepositories(tUsername);

        // assert
        expect(result, equals(tRepoModels));
      },
    );

    test(
      'should throw a ServerException when the response is unsuccessful',
      () async {
        // arrange
        when(
          mockApiHelper.execute(
            method: anyNamed('method'),
            url: anyNamed('url'),
          ),
        ).thenThrow(ServerException());

        // act
        final call = dataSource.getRepositories;

        // assert
        expect(() => call(tUsername), throwsA(isA<ServerException>()));
      },
    );

    test(
      'should throw a ServerException when the response is not a list',
      () async {
        // arrange
        when(
          mockApiHelper.execute(
            method: anyNamed('method'),
            url: anyNamed('url'),
          ),
        ).thenAnswer((_) async => {'error': 'Not found'});

        // act
        final call = dataSource.getRepositories;

        // assert
        expect(() => call(tUsername), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getCommits', () {
    final tOwner = 'testuser';
    final tRepo = 'repo1';
    final tCommitsJsonString = fixture('github_commits.json');
    final tCommitsJson = json.decode(tCommitsJsonString) as List;
    final tCommitModels = tCommitsJson
        .map((commitJson) => GithubCommitModel.fromJson(commitJson))
        .toList();

    test(
      'should perform a GET request with owner and repo in the endpoint',
      () async {
        // arrange
        when(
          mockApiHelper.execute(
            method: anyNamed('method'),
            url: anyNamed('url'),
          ),
        ).thenAnswer((_) async => json.decode(tCommitsJsonString));

        // act
        await dataSource.getCommits(tOwner, tRepo);

        // assert
        final expectedUrl =
            '${GithubApiUrls.repoCommits(tOwner, tRepo)}?per_page=3';
        verify(mockApiHelper.execute(method: Method.get, url: expectedUrl));
      },
    );

    test(
      'should return List<GithubCommitModel> when the response is successful',
      () async {
        // arrange
        when(
          mockApiHelper.execute(
            method: anyNamed('method'),
            url: anyNamed('url'),
          ),
        ).thenAnswer((_) async => json.decode(tCommitsJsonString));

        // act
        final result = await dataSource.getCommits(tOwner, tRepo);

        // assert
        expect(result, equals(tCommitModels));
      },
    );

    test(
      'should throw a ServerException when the response is unsuccessful',
      () async {
        // arrange
        when(
          mockApiHelper.execute(
            method: anyNamed('method'),
            url: anyNamed('url'),
          ),
        ).thenThrow(ServerException());

        // act
        final call = dataSource.getCommits;

        // assert
        expect(() => call(tOwner, tRepo), throwsA(isA<ServerException>()));
      },
    );

    test(
      'should throw a ServerException when the response is not a list',
      () async {
        // arrange
        when(
          mockApiHelper.execute(
            method: anyNamed('method'),
            url: anyNamed('url'),
          ),
        ).thenAnswer((_) async => {'error': 'Not found'});

        // act
        final call = dataSource.getCommits;

        // assert
        expect(() => call(tOwner, tRepo), throwsA(isA<ServerException>()));
      },
    );
  });
}
