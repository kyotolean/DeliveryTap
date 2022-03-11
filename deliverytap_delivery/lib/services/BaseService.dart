import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseService {
  late CollectionReference ref;

  Future<DocumentReference> addDocument(Map<String, dynamic> data) async {
    var doc = await ref.add(data);
    doc.update({'id': doc.id});
    return doc;
  }

  Future<void> addDocumentWithCustomId(String id, Map<String, dynamic> data) async {
    await ref.doc(id).set(data);
  }

  Future<void> updateDocument(String? id, Map<String, dynamic> data) async {
    return await ref.doc(id).update(data);
  }

  Future<void> deleteDocument(String id) async {
    return await ref.doc(id).delete();
  }
}
