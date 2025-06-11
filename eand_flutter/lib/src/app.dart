import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'configs/injector/injector_conf.dart';
import 'core/themes/app_theme.dart';
import 'features/github_repos/presentation/bloc/github_repo_bloc.dart';
import 'routes/app_route_conf.dart';
import 'routes/app_route_path.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouteConf>().router;
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        child: MultiBlocProvider(
          providers: [
            // BlocProvider(create: (_) => getIt<ThemeBloc>()),
            BlocProvider(create: (_) => getIt<GithubRepoBloc>()),
          ],

          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,

            theme: AppTheme.data(false),
            routerConfig: router,
          ),
        ),
      ),
    );
  }
}
