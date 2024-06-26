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
  int uploaded_profile_picture_status;
  String? uploaded_profile_picture;

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
      this.uploaded_profile_picture_status = 0,
      this.uploaded_profile_picture});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'occupation': occupation,
      'relationship': relationship,
      'disability_familiarity': disability_familiarity,
      'accommodations': accommodations,
      'location_preference': location_preference,
      'profile_picture_path': profile_picture_path,
      'uploaded_profile_picture_status': uploaded_profile_picture_status,
      'uploaded_profile_picture': uploaded_profile_picture ?? "",
    };
  }

  ProfileData.fromFirestore(Map<String, dynamic> firestoreData)
      : name = firestoreData['name'],
        age = firestoreData['age'],
        gender = firestoreData['gender'],
        occupation = firestoreData['occupation'],
        relationship = firestoreData['relationship'],
        disability_familiarity =
            List<String>.from(firestoreData['disability_familiarity']),
        accommodations = List<String>.from(firestoreData['accommodations']),
        location_preference =
            List<String>.from(firestoreData['location_preference']),
        profile_picture_path = firestoreData['profile_picture_path'],
        uploaded_profile_picture_status =
            firestoreData['uploaded_profile_picture_status'],
        uploaded_profile_picture = firestoreData['uploaded_profile_picture'];
}
