import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCollection {
  static const String userCollectionName = 'user';
  static const String shopCollectionName = 'shop';
  static const String barberCollectionName = 'barber';
  static const String userRatingCollectionName = 'rating';
  static const String bookAppointmentCollectionName = 'appointment';
  static const String chatCollectionName = 'chats';
  static const String messageCollectionName = 'chats';
  static const String chatRoomCollectionName = 'chatrooms';
  CollectionReference userCollection = FirebaseFirestore.instance.collection(userCollectionName);
  CollectionReference shopCollection = FirebaseFirestore.instance.collection(shopCollectionName);
  CollectionReference barberCollection = FirebaseFirestore.instance.collection(barberCollectionName);
  CollectionReference userRatingCollection = FirebaseFirestore.instance.collection(userRatingCollectionName);
  CollectionReference bookAppointmentCollection = FirebaseFirestore.instance.collection(bookAppointmentCollectionName);
  CollectionReference chatCollection = FirebaseFirestore.instance.collection(chatCollectionName);
  CollectionReference chatRoomCollection = FirebaseFirestore.instance.collection(chatRoomCollectionName);
}