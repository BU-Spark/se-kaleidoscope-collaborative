import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaleidoscope_collaborative/config/globals.dart' as globals;

class CloudFirestoreService {
  final FirebaseFirestore firestore;

  CloudFirestoreService(this.firestore);

  Future<String> addUserDataForAuthUser({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    final sanitized = Map<String, dynamic>.from(data)..remove('password');
    await firestore.collection('User').doc(uid).set(sanitized, SetOptions(merge: true));
    return uid;
  }

  Future<String> addUserData(Map<String, dynamic> data) async {
    final sanitized = Map<String, dynamic>.from(data)..remove('password');
    final document = firestore.collection('User').add(sanitized);
    return document.then((value) => value.id);
  }

  Future<Map<String, dynamic>?> getUserDataForCurrentAuthUser({
    required String uid,
    String? email,
  }) async {
    final uidDoc = await firestore.collection('User').doc(uid).get();
    if (uidDoc.exists) {
      return uidDoc.data();
    }

    if (email == null || email.isEmpty) {
      return null;
    }

    final query = await firestore
        .collection('User')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    return query.docs.first.data();
  }

  Future<String> addUserRating(Map<String, dynamic> data) async {
    // Add a new document with a generated ID
    final document = firestore.collection('UserRating').add(data);
    return document.then((value) => value.id);
  }

  Future<String> addOrUpdateProfileData(Map<String, dynamic> data) async {
    {
      // Using global userEmail as the document ID
      DocumentReference document =
          firestore.collection('ProfileData').doc(globals.userEmail);
      await document
          .set(data); // This will create or update the data at the document ID
      return document.id; // Returns the userEmail, now used as the document ID
    }
  }

  Future<bool> profileDataExists() async {
    try {
      // Use the global userEmail to access the specific document in the 'ProfileData' collection.
      DocumentSnapshot documentSnapshot = await firestore
          .collection('ProfileData')
          .doc(globals.userEmail)
          .get();

      // Return true if the document exists and contains data, otherwise false.
      return documentSnapshot.exists;
    } catch (e) {
      print('Error checking profile data existence: $e');
      // Optionally handle errors or rethrow to manage them elsewhere.
      throw Exception('Failed to check if profile data exists');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return firestore.collection('User').snapshots();
  }
}
