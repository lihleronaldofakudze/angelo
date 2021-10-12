import 'package:angelo/models/Gallery.dart';
import 'package:angelo/models/Photographer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  final String? imageId;

  DatabaseService({this.uid, this.imageId});

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('angelo_users');

  final CollectionReference _galleryCollection =
      FirebaseFirestore.instance.collection('angelo_gallery');

  //User Actions
  Future setUserProfile({required String image, required String username}) {
    return _usersCollection
        .doc(uid)
        .set({'image': image, 'username': username});
  }

  Photographer _photographerFromSnapshot(DocumentSnapshot snapshot) {
    return Photographer(
        image: snapshot.get('image'), username: snapshot.get('username'));
  }

  Stream<Photographer> get photographer {
    return _usersCollection.doc(uid).snapshots().map(_photographerFromSnapshot);
  }

  //Gallery Actions
  Future addImage({required String image, required String name}) {
    return _galleryCollection.add({
      'image': image,
      'uid': uid,
      'postedAt': new DateTime.now(),
      'name': name
    });
  }

  Gallery _galleryFromSnapshot(DocumentSnapshot snapshot) {
    return Gallery(
        id: snapshot.id,
        image: snapshot.get('image'),
        uid: snapshot.get('uid'),
        name: snapshot.get('name'),
        postedAt: snapshot.get('postedAt'));
  }

  List<Gallery> _galleriesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Gallery(
          id: doc.id,
          image: doc.get('image'),
          uid: doc.get('uid'),
          name: doc.get('name'),
          postedAt: doc.get('postedAt'));
    }).toList();
  }

  Stream<Gallery> get gallery {
    return _galleryCollection
        .doc(imageId)
        .snapshots()
        .map(_galleryFromSnapshot);
  }

  Stream<List<Gallery>> get galleries {
    return _galleryCollection
        .orderBy('postedAt', descending: true)
        .snapshots()
        .map(_galleriesFromSnapshot);
  }

  Future deleteImage() {
    return _galleryCollection.doc(imageId).delete();
  }
}
