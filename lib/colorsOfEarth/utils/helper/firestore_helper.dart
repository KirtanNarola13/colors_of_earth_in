import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colors_of_earth/colorsOfEarth/utils/shopify/shopify.dart';
import 'package:get/get.dart'; // Import Get for snackbar
import 'package:shopify_flutter/shopify_flutter.dart';

import 'api_helper.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static final FirestoreHelper firestoreHelper = FirestoreHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addCollection() async {
    try {
      List<Collection> collections = await Shopify.shopify.getCollection();

      for (var e in collections) {
        var products = await ApiHelper.apiHelper
            .getProductFromCollection(e.id.split('/').last);

        if (products == null || products.isEmpty) {
          continue;
        } else {
          var docRef =
              firestore.collection("collections").doc(e.id.split('/').last);
          var docSnapshot = await docRef.get();

          if (!docSnapshot.exists) {
            // If the document does not exist, create it
            await docRef.set({
              'id': e.id,
              'title': e.title,
              // Add other fields you want to store
            });
          }
        }
      }
    } catch (error) {
      Get.snackbar('Error', 'Oops, something went wrong adding the collection');
      log('Error in addCollection: $error');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCollection() {
    try {
      return firestore.collection('collections').snapshots();
    } catch (error) {
      Get.snackbar(
          'Error', 'Oops, something went wrong fetching the collection');
      log('Error in getCollection: $error');
      throw error; // Re-throw the error if needed to prevent app logic from breaking
    }
  }
}
