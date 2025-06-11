import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_checker.dart';
import '../../domain/entities/github_commit_entity.dart';
import '../../domain/entities/github_repo_entity.dart';
import '../../domain/repositories/github_repository.dart';
import '../datasources/github_local_datasource.dart';
import '../datasources/github_remote_datasource.dart';

class GithubRepositoryImpl implements GithubRepository {
  final GithubRemoteDataSource remoteDataSource;
  final GithubLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  GithubRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<GithubRepoEntity>>> getRepositories(
    String username, {
    bool forceRefresh = false,
  }) async {
    return await networkInfo.check(
      onConnected: () async {
        try {
          // Fetch from remote
          final remoteRepos = await remoteDataSource.getRepositories(username);

          // Cache the data
          await localDataSource.cacheRepositories(username, remoteRepos);

          return Right(remoteRepos);
        } on ServerException {
          // If remote fetch fails, try to get from cache
          try {
            final localRepos = await localDataSource.getRepositories(username);
            return Right(localRepos);
          } on CacheException {
            return Left(ServerFailure());
          }
        }
      },
      onNotConnected: () async {
        try {
          // Try to get from cache when offline
          final localRepos = await localDataSource.getRepositories(username);
          return Right(localRepos);
        } on CacheException {
          return Left(CacheFailure());
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<GithubCommitEntity>>> getCommits(
    String owner,
    String repo, {
    int perPage = 3,
    bool forceRefresh = false,
  }) async {
    return await networkInfo.check(
      onConnected: () async {
        try {
          // Fetch from remote
          final remoteCommits = await remoteDataSource.getCommits(
            owner,
            repo,
            perPage: perPage,
          );

          // Cache the data
          await localDataSource.cacheCommits(owner, repo, remoteCommits);

          return Right(remoteCommits);
        } on ServerException {
          // If remote fetch fails, try to get from cache
          try {
            final localCommits = await localDataSource.getCommits(
              owner,
              repo,
              perPage: perPage,
            );
            return Right(localCommits);
          } on CacheException {
            return Left(ServerFailure());
          }
        }
      },
      onNotConnected: () async {
        try {
          // Try to get from cache when offline
          final localCommits = await localDataSource.getCommits(
            owner,
            repo,
            perPage: perPage,
          );
          return Right(localCommits);
        } on CacheException {
          return Left(CacheFailure());
        }
      },
    );
  }
}
