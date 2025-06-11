import 'package:equatable/equatable.dart';

class GithubCommitEntity extends Equatable {
  final String sha;
  final String message;
  final String authorName;
  final String authorEmail;
  final String date;
  final String url;

  const GithubCommitEntity({
    required this.sha,
    required this.message,
    required this.authorName,
    required this.authorEmail,
    required this.date,
    required this.url,
  });

  @override
  List<Object?> get props => [
        sha,
        message,
        authorName,
        authorEmail,
        date,
        url,
      ];
}