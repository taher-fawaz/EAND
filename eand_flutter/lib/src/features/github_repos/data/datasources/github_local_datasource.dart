import 'dart:convert';

import '../../../../core/cache/local_storage.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/github_commit_model.dart';
import '../models/github_repo_model.dart';

abstract class GithubLocalDataSource {
  Future<List<GithubRepoModel>> getRepositories(String username);
  Future<List<GithubCommitModel>> getCommits(String owner, String repo, {int perPage = 3});
  Future<void> cacheRepositories(String username, List<GithubRepoModel> repositories);
  Future<void> cacheCommits(String owner, String repo, List<GithubCommitModel> commits);
}

class GithubLocalDataSourceImpl implements GithubLocalDataSource {
  final LocalStorage localStorage;
  
  GithubLocalDataSourceImpl({required this.localStorage});

  // Box names for Hive storage
  static const String _reposBoxName = 'github_repos';
  static const String _commitsBoxName = 'github_commits';

  @override
  Future<List<GithubRepoModel>> getRepositories(String username) async {
    try {
      final jsonString = await localStorage.load(
        key: username,
        boxName: _reposBoxName,
      );
      
      if (jsonString == null) {
        throw CacheException();
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => GithubRepoModel.fromJson(json)).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<GithubCommitModel>> getCommits(String owner, String repo, {int perPage = 3}) async {
    try {
      final key = '${owner}_$repo';
      final jsonString = await localStorage.load(
        key: key,
        boxName: _commitsBoxName,
      );
      
      if (jsonString == null) {
        throw CacheException();
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      final commits = jsonList.map((json) => GithubCommitModel.fromJson(json)).toList();
      
      // Return only the requested number of commits
      return commits.length > perPage ? commits.sublist(0, perPage) : commits;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheRepositories(String username, List<GithubRepoModel> repositories) async {
    final jsonList = repositories.map((repo) => repo.toJson()).toList();
    final jsonString = json.encode(jsonList);
    
    await localStorage.save(
      key: username,
      value: jsonString,
      boxName: _reposBoxName,
    );
  }

  @override
  Future<void> cacheCommits(String owner, String repo, List<GithubCommitModel> commits) async {
    final key = '${owner}_$repo';
    final jsonList = commits.map((commit) => commit.toJson()).toList();
    final jsonString = json.encode(jsonList);
    
    await localStorage.save(
      key: key,
      value: jsonString,
      boxName: _commitsBoxName,
    );
  }
}