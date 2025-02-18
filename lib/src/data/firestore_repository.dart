import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker_app_flutter_firebase/src/data/job.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreRepository {
  FirestoreRepository(this._firestore);

  final FirebaseFirestore _firestore;

  // ajout d'un job dans la collection 'jobs'
  Future<void> addJob(String uid, String title, String company) =>
      _firestore.collection('jobs').add({
        // on fait ça pour l'instant mais c'est une erreur
        'uid': uid,
        'title': title,
        'company': company
      });

  // update d'un job dans la collection 'jobs'
  Future<void> updateJob(
          String uid, String jobId, String title, String company) =>
      _firestore.doc('jobs/$jobId').update({
        // on fait ça pour l'instant mais c'est une erreur
        'uid': uid,
        'title': title,
        'company': company
      });

  Future<void> deleteJob(String uid, String jobId) =>
      _firestore.doc('jobs/$jobId').delete();

  // récuperation de la collection 'jobs' et conversion en Job
  Query<Job> jobsQuery(String uid) {
    return _firestore.collection('jobs').withConverter(
        fromFirestore: (snapshot, options) => Job.fromMap(snapshot.data()!),
        toFirestore: (value, options) => value.toMap()).where('uid', isEqualTo: uid);
  }
}

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
});
