import 'package:desmosdemo/entities/entities.dart';
import 'package:desmosdemo/usecases/posts/posts.dart';
import 'package:desmosdemo/usecases/usecases.dart';
import 'package:meta/meta.dart';

/// Allows to sync all the posts that have been created offline as well as
/// all the likes and unlikes that have been set to posts.
class SyncPostsUseCase {
  final PostsRepository _postsRepository;

  SyncPostsUseCase({
    @required PostsRepository postsRepository,
  })  : assert(postsRepository != null),
        _postsRepository = postsRepository;

  /// Syncs the locally stored data to the chain.
  /// Local data contains posts as well as likes and unlikes.
  Future<void> sync() async {
    // Get the posts
    final posts = await _postsRepository.getPosts();
    final syncingPosts = posts
        .where((post) => post.status == PostStatus.TO_BE_SYNCED)
        .map((post) => post.copyWith(status: PostStatus.SYNCING))
        .toList();

    if (syncingPosts.isEmpty) {
      // We do not have any post to be synced, so return.
      return;
    }

    // Set the posts as syncing
    syncingPosts.forEach((post) async {
      await _postsRepository.savePost(post);
    });

    // Send the post transactions
    await _postsRepository.syncPosts(syncingPosts);
  }
}
