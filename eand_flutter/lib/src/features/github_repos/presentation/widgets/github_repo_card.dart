import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/github_repo_entity.dart';

class GithubRepoCard extends StatelessWidget {
  final GithubRepoEntity repository;
  final VoidCallback onTap;

  const GithubRepoCard({
    super.key,
    required this.repository,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 85.h,
        child: Material(
          elevation: 4,
          color: Color(0xFFEBEBE4),
          borderRadius: BorderRadius.circular(12.r),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ),
            leading: _buildRepoAvatar(),
            title: Text(
              repository.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRepoAvatar() {
    return Container(
      width: 50.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
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
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
      ),
    );
  }
}
