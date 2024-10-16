import 'dart:developer';

import 'package:colors_of_earth/colorsOfEarth/screens/home/components/apiDetailScreen/api_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/helper/api_helper.dart';
import '../../../utils/helper/db_helper.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    products.clear();
    var fetchedProducts = await DbHelper.dbHelper.fetchProduct();
    if (fetchedProducts != null) {
      setState(() {
        products = fetchedProducts;
      });
    }
  }

  Future<void> _deleteProduct(BuildContext context, int index) async {
    String productId = products[index]['id'].toString();
    log('Deleting product with ID: $productId');

    // Show a progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    // Delete the product from the database
    int? result = await DbHelper.dbHelper.deleteProduct(productId);

    if (result != null && result > 0) {
      // Refresh the product list
      await _fetchProducts();

      // Dismiss the dialog and navigate back
      Navigator.pop(context); // Dismiss the progress dialog
    } else {
      // If deletion fails, just pop the progress dialog
      log('Product delete failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: height * 0.06,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, size: 22, color: Colors.black),
        ),
        title: const Text(
          "Wishlist",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      body: products.isEmpty
          ? Center(
              child: Text(
                "No products in wishlist",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: ApiHelper.apiHelper
                      .getProductById(products[index]['product']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          height: height * 0.18,
                          width: width,
                          color: Colors.grey.shade300,
                        ),
                      ));
                    }

                    if (snapshot.hasData) {
                      Map<String, dynamic>? product = snapshot.data;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApiDetailScreen(
                                id: product['id'].toString(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          height: height * 0.18,
                          width: width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        product!['image']['src'],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: width * 0.4,
                                            child: Text(
                                              product['title'],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _deleteProduct(context, index);
                                            },
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: Colors.red.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "₹ ${product['variants'][0]['price']}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(height: height * 0.02),
                                      Text(
                                        product['product_type'],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "Available Sizes",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: height * 0.03,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: product['variants'].length,
                                          itemBuilder: (context, variantIndex) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {});
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                height: height * 0.1,
                                                width: width * 0.06,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Text(
                                                  product['variants']
                                                      [variantIndex]['title'],
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          height: height * 0.18,
                          width: width,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
