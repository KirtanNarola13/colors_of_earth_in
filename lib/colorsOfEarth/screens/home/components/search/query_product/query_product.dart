import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopify_flutter/models/src/product/product.dart';

import '../../../../../utils/shopify/shopify.dart';
import '../../apiDetailScreen/api_detail_screen.dart';

class QueryProduct extends StatefulWidget {
  String query;
  QueryProduct({super.key, required this.query});

  @override
  State<QueryProduct> createState() => _QueryProductState();
}

class _QueryProductState extends State<QueryProduct> {
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
          icon: const LineIcon.arrowLeft(),
        ),
        title: Text(
          "\"${widget.query}\" | result",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      body: FutureBuilder(
          future: Shopify.shopify.getProductFromSearch(widget.query),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: height * 0.39,
                ),
                itemBuilder: (context, index) {
                  Product? product = snapshot.data?[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ApiDetailScreen(
                                    id: product.id.split('/').last),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: height * 0.3,
                            width: width * 0.46,
                            child: FancyShimmerImage(
                              imageUrl: product!.image,
                              shimmerBaseColor: Colors.grey.shade300,
                              shimmerHighlightColor: Colors.grey.shade100,
                              boxFit: BoxFit.cover, // Fit image
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          width: width * 0.4,
                          child: Text(
                            "${product.title}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return GridView.builder(
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: height * 0.3,
                mainAxisSpacing: height * 0.06,
              ),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    color: Colors.white,
                    height: height * 0.5,
                    width: width * 0.41,
                  ),
                );
              },
            );
          }),
    );
  }
}
