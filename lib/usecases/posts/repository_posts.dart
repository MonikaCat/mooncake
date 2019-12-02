import 'package:desmosdemo/entities/entities.dart';

/// Represents the repository that can be used in order to read
/// and write data related to posts, comments and likes.
abstract class PostsRepository {
  /// Returns the post having the given [postId], or `null` if no
  /// such post could be found.
  Future<Post> getPostById(String postId);

  /// Returns the full list of posts available.
  Future<List<Post>> getPosts();

  /// Returns a [Stream] that emits new posts as they are created.
  Stream<Post> get postsStream;

  /// Saves the given [post].
  Future<void> savePost(Post post);

  /// Syncs the given posts by sending them to the blockchain.
  Future<void> syncPosts(List<Post> posts);

  /// Deleted the post having the given [postId].
  Future<void> deletePost(String postId);
}
