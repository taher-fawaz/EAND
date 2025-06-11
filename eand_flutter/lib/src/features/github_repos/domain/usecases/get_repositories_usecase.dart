import 'package:eand_flutter/src/core/errors/failures.dart';
import 'package:eand_flutter/src/core/usecases/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/github_repo_entity.dart';
import '../../domain/repositories/github_repository.dart';

class GetRepositoriesUseCase
    implements UseCase<List<GithubRepoEntity>, GetRepositoriesParams> {
  final GithubRepository repository;

  GetRepositoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<GithubRepoEntity>>> call(
    GetRepositoriesParams params,
  ) async {
    return await repository.getRepositories(
      params.username,
      forceRefresh: params.forceRefresh,
    );
  }
}

class GetRepositoriesParams {
  final String username;
  final bool forceRefresh;

  GetRepositoriesParams({required this.username, this.forceRefresh = false});
}
