import 'dart:async';

import 'package:eand_flutter/src/features/github_repos/domain/entities/github_repo_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/error_widget.dart';
import '../../../../widgets/loading_widget.dart';
import '../bloc/github_repo_bloc_barrel.dart';
import '../widgets/github_repo_bottom_sheet.dart';
import '../widgets/github_repo_horizontal_list.dart';
import '../widgets/github_repo_vertical_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GithubRepoListScreen extends StatefulWidget {
  const GithubRepoListScreen({super.key});

  @override
  State<GithubRepoListScreen> createState() => _GithubRepoListScreenState();
}

class _GithubRepoListScreenState extends State<GithubRepoListScreen> {
  final String _username = 'mralexgray';
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    // Fetch repositories when the screen loads
    context.read<GithubRepoBloc>().add(FetchRepositories(username: _username));
  }

  void _showRepoDetailsBottomSheet(GithubRepoEntity repository) {
    // Show bottom sheet immediately
    _isBottomSheetOpen = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // Check if we need to fetch commits
        final needToFetchCommits = context
            .read<GithubRepoBloc>()
            .state
            .commits
            .isEmpty;

        if (needToFetchCommits) {
          // Dispatch event to fetch commits
          context.read<GithubRepoBloc>().add(
            FetchCommits(
              owner: repository.fullName.split('/')[0],
              repo: repository.name,
            ),
          );
        }

        // Return the bottom sheet with BlocBuilder to update when commits load
        return BlocBuilder<GithubRepoBloc, GithubRepoState>(
          builder: (context, state) {
            return GithubRepoBottomSheet(
              repository: repository,
              commits: state.commits,
              isLoadingCommits: state.commitsStatus == GithubRepoStatus.loading,
              onClose: () {
                _isBottomSheetOpen = false;
                context.read<GithubRepoBloc>().add(CloseRepositoryDetails());
                Navigator.of(context).pop(); // Close the bottom sheet
              },
            );
          },
        );
      },
    ).whenComplete(() {
      _isBottomSheetOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REPOS', style: TextStyle(fontSize: 20)),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: BlocConsumer<GithubRepoBloc, GithubRepoState>(
        listener: (context, state) {
          if (state.isDetailOpen && !_isBottomSheetOpen) {
            final selectedRepo = state.selectedRepository;
            if (selectedRepo != null) {
              _showRepoDetailsBottomSheet(selectedRepo);
            }
          } else if (!state.isDetailOpen && _isBottomSheetOpen) {
            _isBottomSheetOpen = false;
            Navigator.of(context).pop(); // Close the bottom sheet
          }
        },
        builder: (context, state) {
          if (state.status == GithubRepoStatus.loading) {
            return const AppLoadingWidget();
          } else if (state.status == GithubRepoStatus.failure) {
            return AppErrorWidget(state.errorMessage);
          } else if (state.status == GithubRepoStatus.success ||
              state.status == GithubRepoStatus.refreshing) {
            return _buildContent(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, GithubRepoState state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GithubRepoBloc>().add(
          RefreshRepositories(username: _username),
        );
        // Wait for the refresh to complete
        while (context.read<GithubRepoBloc>().state.status ==
            GithubRepoStatus.refreshing) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show a linear progress indicator at the top when refreshing
              if (state.status == GithubRepoStatus.refreshing)
                const LinearProgressIndicator(),

              // Horizontal list (first 5 repos with circular scrolling)
              if (state.horizontalRepos.isNotEmpty) ...[
                GithubRepoHorizontalList(
                  repositories: state.horizontalRepos,
                  onRepoTap: (index) {
                    context.read<GithubRepoBloc>().add(
                      SelectRepository(index: index),
                    );
                  },
                ),
                SizedBox(height: 24.h),
              ],

              // Vertical list (remaining repos)
              if (state.verticalRepos.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'Git Repo',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: GithubRepoVerticalList(
                    repositories: state.verticalRepos,
                    commits: state.commits,
                    onRepoTap: (index) {
                      context.read<GithubRepoBloc>().add(
                        SelectRepository(index: index),
                      );
                    },
                    onCommitsFetch: (owner, repo) {
                      context.read<GithubRepoBloc>().add(
                        FetchCommits(owner: owner, repo: repo),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
