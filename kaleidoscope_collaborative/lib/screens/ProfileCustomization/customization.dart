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
  String profile_pic_path;

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
      this.profile_pic_path = ""});

  void addDisabilityFamiliarity(String familiarity) {
    disability_familiarity = List.from(disability_familiarity)
      ..add(familiarity);
  }

  void removeDisabilityFamiliarity(String familiarity) {
    disability_familiarity = List.from(disability_familiarity)
      ..remove(familiarity);
  }

  void addAccommodation(String accommodation) {
    accommodations = List.from(accommodations)..add(accommodation);
  }

  void removeAccommodation(String accommodation) {
    accommodations = List.from(accommodations)..remove(accommodation);
  }

  void addLocationPreference(String location) {
    location_preference = List.from(location_preference)..add(location);
  }

  void removeLocationPreference(String location) {
    location_preference = List.from(location_preference)..remove(location);
  }
}
