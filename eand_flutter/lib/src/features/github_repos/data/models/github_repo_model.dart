import '../../domain/entities/github_repo_entity.dart';

class GithubRepoModel extends GithubRepoEntity {
  const GithubRepoModel({
    required super.id,
    required super.name,
    required super.fullName,
    super.description,
    super.avatarUrl,
    required super.private,
    required super.htmlUrl,
    super.language,
    required super.stargazersCount,
    required super.watchersCount,
    required super.forksCount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory GithubRepoModel.fromJson(Map<String, dynamic> json) {
    return GithubRepoModel(
      id: json['id'],
      name: json['name'],
      fullName: json['full_name'],
      description: json['description'],
      avatarUrl: json['owner']?['avatar_url'],
      private: json['private'],
      htmlUrl: json['html_url'],
      language: json['language'],
      stargazersCount: json['stargazers_count'],
      watchersCount: json['watchers_count'],
      forksCount: json['forks_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'full_name': fullName,
      'description': description,
      'avatar_url': avatarUrl,
      'private': private,
      'html_url': htmlUrl,
      'language': language,
      'stargazers_count': stargazersCount,
      'watchers_count': watchersCount,
      'forks_count': forksCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}