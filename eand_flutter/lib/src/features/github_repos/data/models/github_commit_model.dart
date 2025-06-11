import '../../domain/entities/github_commit_entity.dart';

class GithubCommitModel extends GithubCommitEntity {
  const GithubCommitModel({
    required super.sha,
    required super.message,
    required super.authorName,
    required super.authorEmail,
    required super.date,
    required super.url,
  });

  factory GithubCommitModel.fromJson(Map<String, dynamic> json) {
    final commit = json['commit'];
    final author = commit['author'];
    
    return GithubCommitModel(
      sha: json['sha'],
      message: commit['message'],
      authorName: author['name'],
      authorEmail: author['email'],
      date: author['date'],
      url: json['html_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sha': sha,
      'commit': {
        'message': message,
        'author': {
          'name': authorName,
          'email': authorEmail,
          'date': date,
        },
      },
      'html_url': url,
    };
  }
}