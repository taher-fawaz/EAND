import 'package:eand_flutter/src/features/github_repos/domain/entities/github_commit_entity.dart';
import 'package:flutter/services.dart';

import '../../features/github_repos/domain/entities/github_repo_entity.dart';

/// A class that handles communication with the native platform.
class PlatformChannel {
  static const MethodChannel _channel = MethodChannel(
    'com.example.eand_flutter/channel',
  );

  /// Sends the selected repository data back to the native platform and closes the Flutter module.
  static Future<void> sendRepositoryAndClose(
    GithubRepoEntity repository,
    List<GithubCommitEntity> commitEntity,
  ) async {
    try {
      // Convert repository to a map that can be sent through the channel
      final Map<String, dynamic> repoData = {
        'id': repository.id,
        'name': repository.name,
        'fullName': repository.fullName,
        'description': repository.description,
        'avatarUrl': repository.avatarUrl,
        'commits': commitEntity.map((commit) {
          return {
            'sha': commit.sha,
            'message': commit.message,
            'authorName': commit.authorName,
          };
        }).toList(),
      };

      // Send the data to the native platform
      await _channel.invokeMethod('selectRepository', repoData);
      SystemNavigator.pop();
    } catch (e) {
      // If there's an error, still try to close the Flutter module
      SystemNavigator.pop();
    }
  }
}
