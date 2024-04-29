import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreService {
  final FirebaseFirestore firestore;

  CloudFirestoreService(this.firestore);

  /*Firestore counts one document as one read, so make sure to limit results
  with queries and limit() as much as possible.
  https://stackoverflow.com/questions/50887442/cloud-firestore-how-is-read-calculated
  */

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

  Future<String> addUserReview(Map<String, dynamic> data) async {
    // Add a new document with a generated ID
    final document = firestore.collection('UserReview').add(data);
    return document.then((value) => value.id);
  }
}
