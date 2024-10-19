import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopify_flutter/shopify_flutter.dart';

class Shopify {
  Shopify._();
  static final Shopify shopify = Shopify._();

  ShopifyStore shopifyStore = ShopifyStore.instance;
  ShopifyAuth shopifyAuth = ShopifyAuth.instance;
  ShopifyCheckout shopifyCheckout = ShopifyCheckout.instance;
  ShopifyCustomer shopifyCustomer = ShopifyCustomer.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Collection>> getCollection() async {
    List<Collection>? collection = await shopifyStore.getAllCollections();

    return collection;
  }

  Future<List<Product>?> getProductFromCollection(String id) {
    return shopifyStore.getAllProductsFromCollectionById(id);
  }

  Future<Collection?> getWomenBanner() {
    return shopifyStore.getCollectionById('328940650649');
  }

  Future<List<Product>?> getAllProduct() {
    return shopifyStore.getAllProducts(
      reverse: false,
    );
  }

  Future<List<Product>?> getProductFromSearch(String query) {
    return shopifyStore.searchProducts(query);
  }

  Future<List<Product>?> getRecomndedProduct(String id) {
    return shopifyStore.getProductRecommendations(id);
  }

  Future<List<Product>?> get8Product() {
    return shopifyStore.getXProductsAfterCursor(8,
        "eyJsYXN0X2lkIjozMzExMjY5NjQzNzcsImxhc3RfdmFsdWUiOiIyMDI0LTA4LTIwIDE2OjE1OjQ0LjAwMDAwMCJ9");
  }

  Future<void> passWordResetEmail(String email) {
    return shopifyAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signInWithEmailOrPassword() async {
    ShopifyUser shopifyUser = await shopifyAuth.signInWithEmailAndPassword(
      email: "kirtannarola1209@gmail.com",
      password: "Mahadev@1209",
    );
  }

  Future<Checkout> createCheckout(Map<String, dynamic> product) async {
    Checkout checkout = await shopifyCheckout.createCheckout(
      lineItems: [
        LineItem(
          title: product['title'],
          quantity: 1,
          variantId: product['variants'][0]['id'].toString(),
          id: product['id'].toString(),
        )
      ],
      shippingAddress: Address(
        address1: 'Luxmi enclave',
        city: 'Surat',
        country: 'India',
        countryCode: 'IN',
        firstName: 'Kirtan',
        lastName: 'Narola',
        phone: '+917778854551',
        zip: '394107',
      ),
      email: 'https.kirtan@gmail.com',
    );
    log(
      checkout.toString(),
    );
    return checkout;
  }
}
