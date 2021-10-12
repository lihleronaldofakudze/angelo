import 'package:cloud_firestore/cloud_firestore.dart';

class Gallery {
  final String id;
  final String image;
  final String uid;
  final String name;
  final Timestamp postedAt;

  Gallery(
      {required this.id,
      required this.image,
      required this.uid,
      required this.name,
      required this.postedAt});
}
