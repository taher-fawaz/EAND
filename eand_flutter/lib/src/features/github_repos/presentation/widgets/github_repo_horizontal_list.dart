import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/github_repo_entity.dart';
import 'github_repo_card.dart';

class GithubRepoHorizontalList extends StatefulWidget {
  final List<GithubRepoEntity> repositories;
  final Function(int index) onRepoTap;

  const GithubRepoHorizontalList({
    super.key,
    required this.repositories,
    required this.onRepoTap,
  });

  @override
  State<GithubRepoHorizontalList> createState() =>
      _GithubRepoHorizontalListState();
}

class _GithubRepoHorizontalListState extends State<GithubRepoHorizontalList> {
  late final PageController _pageController;
  int _currentPage = 0;
  int get _itemCount => widget.repositories.length;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.85,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page % _itemCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: null, // Infinite scrolling
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              final itemIndex = index % _itemCount;
              final repo = widget.repositories[itemIndex];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: GithubRepoCard(
                  repository: repo,
                  onTap: () => widget.onRepoTap(itemIndex),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
        // Page indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _itemCount,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? Colors.black
                    : Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
