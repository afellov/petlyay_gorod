class UserModel {
  final String id;
  final String email;
  final String phone;
  final String name;
  final String avatar;
  final int pointsBalance;
  final int experience;
  final int tasksCompleted;
  final double kilometersWalked;

  UserModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    required this.avatar,
    required this.pointsBalance,
    required this.experience,
    required this.tasksCompleted,
    required this.kilometersWalked,
  });

  // Этот метод превращает "сырой" JSON от сервера в Dart-объект
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      pointsBalance: (json['points_balance'] as num?)?.toInt() ?? 0,
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      tasksCompleted: (json['tasks_completed'] as num?)?.toInt() ?? 0,
      kilometersWalked: (json['kilometers_walked'] as num?)?.toDouble() ?? 0,
    );
  }

  // Этот метод превращает Dart-объект в JSON для отправки на сервер
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'name': name,
      'avatar': avatar,
      'points_balance': pointsBalance,
      'experience': experience,
      'tasks_completed': tasksCompleted,
      'kilometers_walked': kilometersWalked,
    };
  }
}
