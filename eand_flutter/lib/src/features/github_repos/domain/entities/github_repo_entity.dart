import 'package:equatable/equatable.dart';

class GithubRepoEntity extends Equatable {
  final int id;
  final String name;
  final String fullName;
  final String? description;
  final String? avatarUrl;
  final bool private;
  final String htmlUrl;
  final String? language;
  final int stargazersCount;
  final int watchersCount;
  final int forksCount;
  final String createdAt;
  final String updatedAt;

  const GithubRepoEntity({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    this.avatarUrl,
    required this.private,
    required this.htmlUrl,
    this.language,
    required this.stargazersCount,
    required this.watchersCount,
    required this.forksCount,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        fullName,
        description,
        avatarUrl,
        private,
        htmlUrl,
        language,
        stargazersCount,
        watchersCount,
        forksCount,
        createdAt,
        updatedAt,
      ];
}