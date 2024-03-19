// this is the class/data structure that stores user customization data that
// are passed to the database at the end of customization process

class ProfileData {
  final String name;
  final int age;
  final String gender;
  final String occupation;
  String relationship;
  List<String> disability_familiarity;
  List<String> accommodations;
  List<String> location_preference;
  String profile_picture_path;
  int uploaded_profile_picture;

  ProfileData(
      {required this.name,
      required this.age,
      required this.gender,
      required this.occupation,
      this.relationship = "",
      this.disability_familiarity =
          const [], // Remove const and use nullable type
      this.accommodations = const [], // Remove const and use nullable type
      this.location_preference = const [], // Remove const and use nullable type
      this.profile_picture_path = "",
      this.uploaded_profile_picture = 0});
}
