import 'package:colors_of_earth/colorsOfEarth/screens/home/components/search/query_product/query_product.dart';
import 'package:colors_of_earth/colorsOfEarth/utils/helper/firestore_helper.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/helper/api_helper.dart';
import '../apiDetailScreen/api_detail_screen.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextEditingController searchController = TextEditingController();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const LineIcon.arrowLeft()),
                  Container(
                    width: width * 0.85,
                    height: height * 0.04,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade700,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width * 0.75,
                            child: TextField(
                              controller: searchController,
                              onSubmitted: (query) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QueryProduct(
                                              query: query,
                                            )));
                              },
                              textInputAction: TextInputAction.search,
                              decoration: const InputDecoration(
                                hintText: "Search product here",
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 14),
                              ),
                              cursorHeight: height * 0.025,
                              cursorColor: Colors.grey,
                              showCursor: true,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.05,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "# Populer Searches",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.005,
              ),
              SizedBox(
                height: height * 0.055,
                width: width,
                child: StreamBuilder(
                  stream: FirestoreHelper.firestoreHelper.getCollection(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) =>
                            snapshot.data!.docs[index]['title'] == "GST 12%"
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QueryProduct(
                                              query: snapshot.data!.docs[index]
                                                  ['title']),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(6),
                                      padding: const EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      height: height * 0.04,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        snapshot.data!.docs[index]['title'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                      );
                    }
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      enabled: true,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.all(5),
                          alignment: Alignment.center,
                          height: height * 0.04,
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              //todo: New Launched Text
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "# New Launched",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              //todo: New Launched
              SizedBox(
                height: height * 0.36,
                child: FutureBuilder(
                  future: ApiHelper.apiHelper.getNewLaunchedProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          Map<String, dynamic>? product = snapshot.data?[index];
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ApiDetailScreen(
                                          id: product['id'].toString()),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  height: height * 0.25,
                                  width: width * 0.32,
                                  child: FancyShimmerImage(
                                    imageUrl: product!['image']['src'],
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
                                width: width * 0.3,
                                child: Text(
                                  "${product['title']}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      enabled: true,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          Map<String, dynamic>? product = snapshot.data?[index];
                          return Container(
                            margin: const EdgeInsets.only(left: 10, right: 5),
                            color: Colors.white,
                            height: height * 0.3,
                            width: width * 0.41,
                          );
                        },
                      ),
                    );
                    ();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
