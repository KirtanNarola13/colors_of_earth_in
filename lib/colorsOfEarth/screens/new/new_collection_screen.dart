import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colors_of_earth/colorsOfEarth/screens/new/view_collection_product/view_collection_product.dart';
import 'package:colors_of_earth/colorsOfEarth/utils/helper/firestore_helper.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/helper/api_helper.dart';

class NewCollectionScreen extends StatefulWidget {
  const NewCollectionScreen({super.key});

  @override
  State<NewCollectionScreen> createState() => _NewCollectionScreenState();
}

class _NewCollectionScreenState extends State<NewCollectionScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: height * 0.06,
        backgroundColor: Colors.white,
        title: const Text(
          "Collections",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: StreamBuilder(
          stream: FirestoreHelper.firestoreHelper.getCollection(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  List<QueryDocumentSnapshot<Map<String, dynamic>>>?
                      collection = snapshot.data!.docs;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewCollectionProduct(
                            id: collection[index]['id'].split('/').last,
                            name: collection[index]['title'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 15, bottom: 10, right: 10, left: 10),
                      height: height * 0.18,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          FutureBuilder(
                            future: ApiHelper.apiHelper
                                .getProductFromCollection(
                                    collection[index]['id'].split('/').last),
                            builder: (context, snapshot) {
                              List? data = snapshot.data;
                              if (snapshot.hasData) {
                                return SizedBox(
                                  width: width * 0.39,
                                  height: height,
                                  child: FancyShimmerImage(
                                    shimmerBaseColor: Colors.grey.shade300,
                                    shimmerHighlightColor: Colors.grey.shade100,
                                    imageUrl: data!.isNotEmpty
                                        ? data.first['image']['src']
                                        : "",
                                    alignment: Alignment(0, -1),
                                    boxFit: BoxFit.cover, // Fit image
                                  ),
                                  //
                                  // child: Image(
                                  //   image: NetworkImage(
                                  //     data!.isNotEmpty
                                  //         ? data.first['image']['src']
                                  //         : "",
                                  //   ),
                                  //   fit: BoxFit.cover,
                                  //   alignment: Alignment(0, -1),
                                  // ),
                                );
                              }

                              return Container();
                            },
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ShapeOfView(
                              elevation: 0,
                              width: width * 0.65,
                              shape: DiagonalShape(
                                position: DiagonalPosition.Right,
                                direction: DiagonalDirection.Left,
                                angle: DiagonalAngle.deg(angle: 8),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: width,
                                    height: height,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF000000)
                                              .withOpacity(0.8),
                                          offset: Offset(8, -1),
                                          blurRadius: 6,
                                          spreadRadius: -3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: width * 0.65,
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey,
                                            highlightColor: Colors.black54,
                                            child: Text(
                                              collection[index]['title'],
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          alignment: Alignment.center,
                                          height: height * 0.03,
                                          width: width * 0.18,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                          ),
                                          child: const Text(
                                            "Explore",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
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
                },
              );
            }
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 20, bottom: 40),
                  alignment: Alignment.bottomRight,
                  height: height * 0.15,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
