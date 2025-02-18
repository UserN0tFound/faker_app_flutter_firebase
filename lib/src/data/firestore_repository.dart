import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker_app_flutter_firebase/src/data/job.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreRepository {
  FirestoreRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> addJob(String uid, String title, String company) async {
    final docRef = await _firestore.collection('jobs').add({
      // on fait ça pour l'instant mais c'est une erreur
      'uid': uid,
      'title': title,
      'company': company
    });

    debugPrint(docRef.id);
  }

  Query<Job> jobsQuery() {
    return _firestore.collection('jobs').withConverter(
        fromFirestore: (snapshot, options) => Job.fromMap(snapshot.data()!),
        toFirestore: (value, options) => value.toMap());
  }
}

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
});
