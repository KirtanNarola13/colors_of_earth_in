import 'dart:developer';

import 'package:colors_of_earth/colorsOfEarth/screens/home/controller/addToCartController.dart';
import 'package:colors_of_earth/colorsOfEarth/screens/navbar/navigation_bar.dart';
import 'package:colors_of_earth/colorsOfEarth/utils/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/helper/api_helper.dart';
import 'apiDetailScreen/components/web_checkout.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  AddToCartController addToCartController = Get.put(AddToCartController());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    incrementQuantity(int index) {
      setState(() {
        Constant.cartProducts[index]['quantity'] =
            Constant.cartProducts[index]['quantity'] + 1;
      });
    }

    decrementQuantity(int index) {
      setState(() {
        if (Constant.cartProducts[index]['quantity'] > 1) {
          Constant.cartProducts[index]['quantity'] =
              Constant.cartProducts[index]['quantity'] - 1;
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Visibility(
        child: GestureDetector(
          onTap: () {
            if (Constant.cartProducts.isEmpty) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NavigationBarScreen(initIndex: 0)),
                  (route) => false);
            } else if (Constant.cartProducts.isNotEmpty) {
              final List<Map> data = [];
              for (int i = 0; i < Constant.cartProducts.length; i++) {
                data.add({
                  'id': Constant.cartProducts[i]['variant']['id'],
                  'quantity': Constant.cartProducts[i]['quantity'],
                });
              }
              if (data.isNotEmpty) {
                ApiHelper.apiHelper.createCheckout(data).then(
                  (value) {
                    log(value.toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebCheckout(
                          url: value?['data']['checkoutCreate']['checkout']
                              ['webUrl'],
                        ),
                      ),
                    );
                  },
                );
              }
            }
          },
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(15),
            height: height * 0.06,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Text(
              Constant.cartProducts.isEmpty ? "Continue Shopping" : "CHECKOUT",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        toolbarHeight: height * 0.06,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const LineIcon.arrowLeft(
            size: 22,
          ),
        ),
        title: const Text(
          "Cart",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      body: Constant.cartProducts.isEmpty
          ? Center(
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
                        "Your cart is empty",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Check out our new collections",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: Constant.cartProducts.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> product = Constant.cartProducts[index];
                return Container(
                  margin: const EdgeInsets.only(
                      left: 5, right: 5, top: 10, bottom: 20),
                  height: height * 0.25,
                  width: width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                product['image']['src'],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: width * 0.4,
                                    child: Text(
                                      "${product['title']}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Get.snackbar(
                                          'Success', 'Item removed from cart');
                                      Constant.cartProducts.removeAt(index);
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Text(
                                "${product['product_type']}",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Text(
                                "Size : ${product['variant']['title']}",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Container(
                                height: height * 0.04,
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        decrementQuantity(index);
                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.black,
                                        size: 16,
                                      ),
                                    ),
                                    Text(
                                      "${product['quantity']}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        incrementQuantity(index);
                                      },
                                      icon: const Icon(
                                        color: Colors.black,
                                        Icons.add,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Text(
                                "₹ ${product['variant']['price']}",
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
