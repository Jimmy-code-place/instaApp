class Post {
  final int id;
  final String userName;
  final String? content;
  final String? imageUrl;
  final List<Map<String, dynamic>> likes;
  final List<Map<String, dynamic>> comments;

  Post({
    required this.id,
    required this.userName,
    this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
  });
}
