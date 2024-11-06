import 'dart:developer';

import 'package:colors_of_earth/colorsOfEarth/utils/helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:shimmer/shimmer.dart';

import '../../home/components/apiDetailScreen/api_detail_screen.dart';

class ViewCollectionProduct extends StatelessWidget {
  String id;
  String name;
  ViewCollectionProduct({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    log(id.toString());

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
          "$name Products",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      body: FutureBuilder(
          future: ApiHelper.apiHelper.getProductFromCollection(id),
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
                  mainAxisExtent: height * 0.42,
                ),
                itemBuilder: (context, index) {
                  Map<String, dynamic> product = snapshot.data![index];
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
                                    id: product['id'].toString()),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: height * 0.33,
                            width: width * 0.46,
                            child: Image.network(
                              "${product['image']['src']}",
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  enabled: true,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    color: Colors.white,
                                    height: height * 0.5,
                                    width: width * 0.46,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          width: width * 0.4,
                          child: Text(
                            "${product['title']}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
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
                mainAxisExtent: height * 0.42,
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
                    height: height * 0.33,
                    width: width * 0.46,
                  ),
                );
              },
            );
          }),
    );
  }
}
