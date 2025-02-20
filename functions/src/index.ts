import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";
import * as functions from "firebase-functions/v2";

admin.initializeApp();

export const makeJobTitleUppercase = functions.firestore.onDocumentWritten(
  "/users/{uid}/jobs/{jobId}",
  (e) => {
    const change = e.data;
    if (change === undefined) {
      return;
    }
    const data = change.after.data();
    if (data === undefined) {
      // If the document has been deleted, do nothing
      return;
    }
    const uppercase = data.title.toUpperCase();
    // If the title is already uppercase, do nothing (prevents an infinite loop)
    if (uppercase == data.title) {
      return;
    }
    // else, write back to the same document
    logger.log(
      `Uppercasing ${change.after.ref.path}: ${data.title} => ${uppercase}`
    );
    return change.after.ref.set({ title: uppercase }, { merge: true });
  }
);

// Fonction Cloud pour supprimer tous les jobs d'un utilisateur
export const deleteAllUserJobs = functions.https.onCall(
  async (context: functions.https.CallableRequest) => {
    // Récupérer l'UID de l'utilisateur authentifié
    const uid = context.auth?.uid;
    if (uid === undefined) {
      // Si l'utilisateur n'est pas authentifié, lever une erreur
      throw new functions.https.HttpsError(
        "unauthenticated",
        "You need to be authenticated to perform this action"
      );
    }
    // Référence à la collection des jobs de l'utilisateur
    const firestore = admin.firestore();
    const collectionRef = firestore.collection(`/users/${uid}/jobs`);

    // Récupérer toutes les références de documents dans la collection
    const docRefs = await collectionRef.listDocuments();

    // Supprimer chaque document
    for (const docRef of docRefs) {
      await docRef.delete();
    }

    // Logger le nombre de documents supprimés
    logger.log(`Deleted ${docRefs.length} docs at ${collectionRef.path}`);

    // Retourner le nombre de documents supprimés
    return { count: docRefs.length };
  }
);
