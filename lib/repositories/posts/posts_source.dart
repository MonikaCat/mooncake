import 'package:mooncake/entities/entities.dart';

/// Represents the source that should be used when dealing with posts.
abstract class LocalPostsSource {
  /// Returns the post having the given [id].
  /// If no post with the given id was found, returns `null` instead.
  Future<Post> getPostById(String postId);

  /// Returns the list of all posts that represent comments to
  /// the post having the given [postId].
  Future<List<Post>> getPostComments(String postId);

  /// Returns the list of all the currently stored posts.
  Future<List<Post>> getPosts();

  /// Returns the list of all the posts to be synced.
  Future<List<Post>> getPostsToSync();

  /// Returns a stream that emits new posts as soon as they
  /// are stored into the source.
  Stream<Post> get postsStream;

  /// Saves the given [post] inside the source, returning it
  /// after it has being created.
  /// If [emit] is `true`, the new post will be emitted to the posts
  /// stream.
  Future<void> savePost(Post post, {bool emit = true});

  /// Saves the given list of [posts] into the source.
  Future<void> savePosts(List<Post> posts, {bool emit = true});

  /// Deleted the post having the given [postId].
  Future<void> deletePost(String postId);
}
