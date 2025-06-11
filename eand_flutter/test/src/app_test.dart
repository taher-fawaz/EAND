import 'package:eand_flutter/src/app.dart';
import 'package:eand_flutter/src/configs/injector/injector_conf.dart';
import 'package:eand_flutter/src/features/github_repos/presentation/bloc/github_repo_bloc.dart';
import 'package:eand_flutter/src/routes/app_route_conf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_test.mocks.dart';

@GenerateMocks([AppRouteConf, GithubRepoBloc])
void main() {
  late MockAppRouteConf mockAppRouteConf;
  late MockGithubRepoBloc mockGithubRepoBloc;
  late GoRouter mockRouter;

  setUp(() {
    mockAppRouteConf = MockAppRouteConf();
    mockGithubRepoBloc = MockGithubRepoBloc();
    mockRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Mock Home Screen'))),
        ),
      ],
    );

    // Setup GetIt
    GetIt.instance.reset();
    getIt.registerSingleton<AppRouteConf>(mockAppRouteConf);
    getIt.registerFactory<GithubRepoBloc>(() => mockGithubRepoBloc);

    // Mock the router
    when(mockAppRouteConf.router).thenReturn(mockRouter);
  });

  testWidgets('MyApp should build without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('MyApp should use the router from AppRouteConf', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the router is used
    verify(mockAppRouteConf.router);
  });

  testWidgets('MyApp should provide GithubRepoBloc', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the bloc provider is created
    expect(getIt<GithubRepoBloc>(), equals(mockGithubRepoBloc));
  });
}
