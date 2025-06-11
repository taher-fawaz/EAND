import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/platform/platform_channel.dart';
import '../../../../widgets/loading_widget.dart';
import '../../domain/entities/github_commit_entity.dart';
import '../../domain/entities/github_repo_entity.dart';
import 'github_repo_commits_list.dart';

class GithubRepoBottomSheet extends StatelessWidget {
  final GithubRepoEntity repository;
  final List<GithubCommitEntity> commits;
  final bool isLoadingCommits;
  final VoidCallback onClose;

  const GithubRepoBottomSheet({
    super.key,
    required this.repository,
    required this.commits,
    required this.isLoadingCommits,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRepoInfo(),
                  SizedBox(height: 24.h),
                  _buildCommitsSection(),
                  SizedBox(height: 24.h),
                  _buildSelectButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 24),
          Flexible(
            child: Text(
              repository.name,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: onClose),
        ],
      ),
    );
  }

  Widget _buildRepoInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildRepoAvatar(),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    repository.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (repository.description != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      repository.description!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 16.w,
          children: [
            _buildStatItem(
              Icons.star,
              '${repository.stargazersCount}',
              'Stars',
            ),
            _buildStatItem(
              Icons.remove_red_eye,
              '${repository.watchersCount}',
              'Watchers',
            ),
            _buildStatItem(
              Icons.fork_right,
              '${repository.forksCount}',
              'Forks',
            ),
            if (repository.language != null)
              _buildStatItem(Icons.code, repository.language!, 'Language'),
          ],
        ),
      ],
    );
  }

  Widget _buildRepoAvatar() {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: repository.avatarUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                repository.avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackAvatar();
                },
              ),
            )
          : _buildFallbackAvatar(),
    );
  }

  Widget _buildFallbackAvatar() {
    return Center(
      child: Text(
        repository.name.isNotEmpty ? repository.name[0].toUpperCase() : 'G',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20.r),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildCommitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Commit History',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        if (isLoadingCommits)
          const AppLoadingWidget()
        else if (commits.isEmpty)
          Text(
            'No commits found',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          )
        else
          GithubRepoCommitsList(commits: commits),
      ],
    );
  }

  Widget _buildSelectButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          // Send the repository data back to the native side and close the Flutter module
          PlatformChannel.sendRepositoryAndClose(repository, commits);

          // Also call the original onClose callback to maintain existing behavior
          // onClose();
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          side: BorderSide(color: Colors.black, width: 2.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          'Select Repo',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
