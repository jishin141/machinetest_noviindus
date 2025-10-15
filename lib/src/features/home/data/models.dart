class CategoryModel {
  final String id;
  final String title;

  CategoryModel({required this.id, required this.title});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'].toString(), // ✅ always store as String
      title: json['title'] ?? '',
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String? avatar;
  UserModel({required this.id, required this.name, this.avatar});
  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id: j['id'] as int,
    name: j['name']?.toString() ?? '',
    avatar: j['image'] as String?,
  );
}

class FeedModel {
  final int id;
  final String? thumbnailUrl;
  final String videoUrl;
  final String description;
  final UserModel user;
  final String? createdAt;
  FeedModel({
    required this.id,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.description,
    required this.user,
    this.createdAt,
  });
  factory FeedModel.fromJson(Map<String, dynamic> j) => FeedModel(
    id: j['id'] as int,
    thumbnailUrl: j['thumbnail'] as String? ?? j['image'] as String?,
    videoUrl: j['video'] as String? ?? '',
    description: j['desc']?.toString() ?? j['description']?.toString() ?? '',
    user: UserModel.fromJson(j['user'] as Map<String, dynamic>),
    createdAt: j['created_at'] as String?,
  );
}
