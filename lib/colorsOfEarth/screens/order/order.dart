import 'dart:convert';

import 'package:colors_of_earth/colorsOfEarth/screens/order/const/const.dart';
import 'package:colors_of_earth/colorsOfEarth/utils/helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constant/constant.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: (token == null && customerId == null)
          ? const Center(
              child: Text("First Login Your Account"),
            )
          : FutureBuilder(
              future: ApiHelper.apiHelper.getOrder(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                } else if (snapshot.hasData) {
                  Map<String, dynamic> data =
                      jsonDecode(snapshot.data.toString());
                  List orders = data['orders'];
                  return orders.isEmpty
                      ? const Center(child: Text("No Order"))
                      : ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> order = orders[index];

                            return SizedBox(
                              height: height,
                              child: ListView.builder(
                                itemCount: order['line_items'].length,
                                itemBuilder: (context, index) {
                                  return FutureBuilder(
                                    future: ApiHelper.apiHelper.getProductById(
                                        order['line_items'][index]['product_id']
                                            .toString()),
                                    builder: (context, snapshot) {
                                      Map<String, dynamic> product =
                                          snapshot.data ?? {};
                                      if (snapshot.hasData) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              left: 5,
                                              right: 5,
                                              top: 10,
                                              bottom: 20),
                                          height: height * 0.25,
                                          width: width,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: product == null
                                                    ? Container()
                                                    : Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                              "${product['image']['src']}",
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: width * 0.4,
                                                            child: Text(
                                                              "${order['line_items'][0]['name']}",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.02,
                                                      ),
                                                      Text(
                                                        "${order['line_items'][0]['price']}",
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.02,
                                                      ),
                                                      Text(
                                                        "${order['payment_gateway_names']}",
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.02,
                                                      ),
                                                      Text(
                                                        "confirmed => ${order['confirmed']}",
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.02,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                }
                return Center(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: Image(
                        image: NetworkImage(
                          Constant.constant.remoteConfig
                                  ?.getString('colorsOfearth') ??
                              "",
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
