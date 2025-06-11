import '../../../configs/injector/injector_conf.dart';
import '../../../core/cache/hive_local_storage.dart';
import '../data/datasources/github_local_datasource.dart';
import '../data/datasources/github_remote_datasource.dart';
import '../data/repositories/github_repository_impl.dart';
import '../domain/repositories/github_repository.dart';
import '../domain/usecases/get_commits_usecase.dart';
import '../domain/usecases/get_repositories_usecase.dart';
import '../presentation/bloc/github_repo_bloc.dart';

class GithubDependency {
  static void init() {
    // Data sources
    getIt.registerLazySingleton<GithubRemoteDataSource>(
      () => GithubRemoteDataSourceImpl(apiHelper: getIt()),
    );
    
    getIt.registerLazySingleton<GithubLocalDataSource>(
      () => GithubLocalDataSourceImpl(localStorage: getIt<HiveLocalStorage>()),
    );

    // Repositories
    getIt.registerLazySingleton<GithubRepository>(
      () => GithubRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        networkInfo: getIt(),
      ),
    );

    // Use cases
    getIt.registerLazySingleton(
      () => GetRepositoriesUseCase(getIt()),
    );

    getIt.registerLazySingleton(
      () => GetCommitsUseCase(getIt()),
    );

    // BLoC
    getIt.registerFactory(
      () => GithubRepoBloc(
        getRepositoriesUseCase: getIt(),
        getCommitsUseCase: getIt(),
      ),
    );
  }
}