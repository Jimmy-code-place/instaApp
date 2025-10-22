class PostModel {
  final int id;
  final String userName;
  final String? content;
  final String? imageUrl;
  final int likeCount;
  final List<CommentModel> comments;

  PostModel({
    required this.id,
    required this.userName,
    this.content,
    this.imageUrl,
    required this.likeCount,
    required this.comments,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userName: json['user']['name'],
      content: json['content'],
      imageUrl: json['image_url'],
      likeCount: json['likes'].length,
      comments: (json['comments'] as List)
          .map((c) => CommentModel.fromJson(c))
          .toList(),
    );
  }
}

class CommentModel {
  final String userName;
  final String content;

  CommentModel({required this.userName, required this.content});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      userName: json['user']['name'],
      content: json['content'],
    );
  }
}
