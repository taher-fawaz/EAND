import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/github_commit_entity.dart';
import '../entities/github_repo_entity.dart';

abstract class GithubRepository {
  Future<Either<Failure, List<GithubRepoEntity>>> getRepositories(
    String username, {
    bool forceRefresh = false,
  });
  Future<Either<Failure, List<GithubCommitEntity>>> getCommits(
    String owner,
    String repo, {
    int perPage = 3,
    bool forceRefresh = false,
  });
}
