import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreService {
  final FirebaseFirestore firestore;

  CloudFirestoreService(this.firestore);

  Future<String> addUserData(Map<String, dynamic> data) async {
    // Add a new document with a generated ID
    final document = firestore.collection('User').add(data);
    return document.then((value) => value.id);
  }

  Future<String> addUserRating(Map<String, dynamic> data) async {
    // Add a new document with a generated ID
    final document = firestore.collection('UserRating').add(data);
    return document.then((value) => value.id);
  }

  Future<String> addProfileData(Map<String, dynamic> data) async {
    // Add a new document with a generated ID
    final document = firestore.collection('ProfileData').add(data);
    return document.then((value) => value.id);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return firestore.collection('User').snapshots();
  }
}
