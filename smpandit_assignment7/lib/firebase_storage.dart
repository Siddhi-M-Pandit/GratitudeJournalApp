import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class CFStorage {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload an image
  Future<String> uploadImage(File imageFile, String userId) async {
    Reference ref = _storage.ref().child('users/$userId/images/${DateTime.now().toIso8601String()}');
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  // Add a new journal entry
  Future<void> addJournalEntry(String text, String? imageUrl, int rating) async {
    await _db.collection('journal_entries').add({
      'text': text,
      'imageUrl': imageUrl,
      'rating': rating,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Read journal entries
  Stream<QuerySnapshot> getJournalEntries() {
    return _db.collection('journal_entries').orderBy('timestamp', descending: true).snapshots();
  }

}
