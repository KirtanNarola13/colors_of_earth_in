import 'dart:convert';

import 'package:colors_of_earth/colorsOfEarth/screens/profile/authantication/sign_in.dart';
import 'package:colors_of_earth/colorsOfEarth/screens/profile/controller/loginController.dart';
import 'package:colors_of_earth/colorsOfEarth/utils/helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../constant/constant.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  Future<void> cancelOrder(int orderId) async {
    try {
      final response = await ApiHelper.apiHelper.cancelOrder(orderId);

      Logger().i("cancel order response: ${response.body}");
      if (response != null) {
        final responseData = jsonDecode(response.body);
        if (response.statusCode == 200) {
          Get.snackbar('Success', 'Order canceled successfully');
          // Optionally, refresh or update the order list here after canceling
          setState(() {}); // Refresh UI after cancellation
        } else {
          Get.snackbar('Oops', 'Something went wrong');
        }
      }
    } catch (e) {
      Logger().e("Error canceling order: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    LoginController loginController = Get.put(LoginController());
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Visibility(
        visible: !loginController.isLogin.value,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignIn(),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: height * 0.06,
                width: width * 0.95,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: (!loginController.isLogin.value)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/lock.json',
                    height: height * 0.35,
                  ),
                  const Column(
                    children: [
                      Text(
                        "You are not login yet",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Please login first to see your order history",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
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

                  Logger().i("product length ${orders.length}");

                  if (orders.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Lottie.asset(
                            'assets/lottie/empty.json',
                            height: height * 0.7,
                            width: width * 0.75,
                          ),
                          Column(
                            children: [
                              Text(
                                "You don't have any order yet",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Please order something to see your order history",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: height,
                      child: ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, orderIndex) {
                          Map<String, dynamic> order = orders[orderIndex];

                          // List for storing all line items' widgets
                          List<Widget> lineItemWidgets = [];

                          // Add each line item
                          for (var lineItem in order['line_items']) {
                            lineItemWidgets.add(
                              FutureBuilder(
                                future: ApiHelper.apiHelper.getProductById(
                                  lineItem['product_id'].toString(),
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    Map<String, dynamic> product =
                                        snapshot.data ?? {};

                                    return Container(
                                      margin: const EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 10,
                                          bottom: 20),
                                      height: height * 0.22,
                                      width: width,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: product == null
                                                ? Container()
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
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
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: width * 0.4,
                                                        child: Text(
                                                          "${lineItem['name']}",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.005,
                                                  ),
                                                  Text(
                                                    "₹ ${lineItem['price']}",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                                  Text(
                                                    "Size : ${lineItem['variant_title']}",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.005,
                                                  ),
                                                  Text(
                                                    "Discount : ${lineItem['total_discount']}",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.005,
                                                  ),
                                                  Text(
                                                    "${order['payment_gateway_names'].toString().replaceAll('[', '').replaceAll(']', '')}",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      cancelOrder(order['id']);
                                                    },
                                                    child: Container(
                                                      height: height * 0.03,
                                                      width: width * 0.2,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.grey.shade50,
                                                        border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        "cancel",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
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
                              ),
                            );
                          }

                          // Return the order header and the list of line items
                          return Column(
                            children: [
                              Column(children: lineItemWidgets),
                            ],
                          );
                        },
                      ),
                    );
                  }
                }

                return Center(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: Image(
                        image: NetworkImage(
                          Constants.instance.remoteConfig
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
