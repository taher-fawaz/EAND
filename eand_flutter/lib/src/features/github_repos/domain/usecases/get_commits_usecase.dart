import 'package:eand_flutter/src/core/errors/failures.dart';
import 'package:eand_flutter/src/core/usecases/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/github_commit_entity.dart';
import '../../domain/repositories/github_repository.dart';

class GetCommitsUseCase
    implements UseCase<List<GithubCommitEntity>, GetCommitsParams> {
  final GithubRepository repository;

  GetCommitsUseCase(this.repository);

  @override
  Future<Either<Failure, List<GithubCommitEntity>>> call(
    GetCommitsParams params,
  ) async {
    return await repository.getCommits(
      params.owner,
      params.repo,
      perPage: params.perPage,
      forceRefresh: params.forceRefresh,
    );
  }
}

class GetCommitsParams {
  final String owner;
  final String repo;
  final int perPage;
  final bool forceRefresh;

  GetCommitsParams({
    required this.owner,
    required this.repo,
    this.perPage = 3,
    this.forceRefresh = false,
  });
}
