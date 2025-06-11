import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/github_commit_entity.dart';
import '../../domain/entities/github_repo_entity.dart';
import 'github_repo_card.dart';
import 'github_repo_commits_list.dart';

class GithubRepoVerticalList extends StatelessWidget {
  final List<GithubRepoEntity> repositories;
  final List<GithubCommitEntity> commits;
  final Function(int index) onRepoTap;
  final Function(String owner, String repo) onCommitsFetch;

  const GithubRepoVerticalList({
    super.key,
    required this.repositories,
    required this.commits,
    required this.onRepoTap,
    required this.onCommitsFetch,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: repositories.length,
      itemBuilder: (context, index) {
        final repo = repositories[index];
        
        return Column(
          children: [
            GithubRepoCard(
              repository: repo,
              onTap: () => onRepoTap(index),
              // Changed from onExpand to use onTap for showing bottom sheet
              // This removes the dropdown behavior and uses the bottom sheet instead
            ),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }
}
