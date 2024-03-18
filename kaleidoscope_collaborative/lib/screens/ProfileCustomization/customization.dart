class ProfileData {
  final String name;
  final int age;
  final String gender;
  final String occupation;
  String relationship;

  ProfileData({
    required this.name,
    required this.age,
    required this.gender,
    required this.occupation,
    this.relationship = "",
  });
}
