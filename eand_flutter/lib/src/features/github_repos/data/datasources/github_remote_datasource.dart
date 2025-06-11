import 'package:dio/dio.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/api/api_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/github_commit_model.dart';
import '../models/github_repo_model.dart';
import 'github_api_urls.dart';

abstract class GithubRemoteDataSource {
  Future<List<GithubRepoModel>> getRepositories(String username);
  Future<List<GithubCommitModel>> getCommits(
    String owner,
    String repo, {
    int perPage = 3,
  });
}

class GithubRemoteDataSourceImpl implements GithubRemoteDataSource {
  final ApiHelper apiHelper;

  GithubRemoteDataSourceImpl({required this.apiHelper});

  @override
  Future<List<GithubRepoModel>> getRepositories(String username) async {
    try {
      final response = await apiHelper.execute(
        method: Method.get,
        url: GithubApiUrls.userRepos(username),
      );

      if (response is List) {
        return response.map((repo) => GithubRepoModel.fromJson(repo)).toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException();
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException();
    }
  }

  @override
  Future<List<GithubCommitModel>> getCommits(
    String owner,
    String repo, {
    int perPage = 3,
  }) async {
    try {
      final url = '${GithubApiUrls.repoCommits(owner, repo)}?per_page=$perPage';
      final response = await apiHelper.execute(method: Method.get, url: url);

      if (response is List) {
        return response
            .map((commit) => GithubCommitModel.fromJson(commit))
            .toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw ServerException();
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException();
    }
  }
}
