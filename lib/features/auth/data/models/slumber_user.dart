class SlumberUser {
  final String id;
  final String email;
  final String name;
  final int sleepGoalHours;
  final int age;
  final String? bedtime;

  SlumberUser({
    required this.id,
    required this.email,
    required this.name,
    this.sleepGoalHours = 8,
    this.age = 0,
    this.bedtime,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "sleepGoalHours": sleepGoalHours,
      "age": age,
      "bedtime": bedtime,
    };
  }

  factory SlumberUser.fromMap(Map<String, dynamic> data) {
    return SlumberUser(
      id: data["id"],
      email: data["email"],
      name: data["name"],
      sleepGoalHours: data["sleepGoalHours"] ?? 8,
      age: data["age"] ?? 0,
      bedtime: data["bedtime"],
    );
  }
}
