import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FunctionsRepository {
  FunctionsRepository(this._functions);
  final FirebaseFunctions _functions;

  // Méthode pour appeler la fonction Cloud 'deleteAllUserJobs'
  Future<void> deleteAllUserJobs() async {
    // Créer un objet callable pour la fonction Cloud 'deleteAllUserJobs'
    final callable = _functions.httpsCallable('deleteAllUserJobs');

    // Appeler la fonction Cloud et attendre le résultat
    final result = await callable();

    // Afficher le résultat dans la console pour le débogage
    debugPrint(result.data.toString());
  }
}

final functionsRepositoryProvider = Provider<FunctionsRepository>((ref) {
  return FunctionsRepository(FirebaseFunctions.instance);
});
