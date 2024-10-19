import 'package:audioplayers/audioplayers.dart';
import 'package:badges/badges.dart' as badges;
import 'package:colors_of_earth/colorsOfEarth/screens/home/components/cart.dart';
import 'package:colors_of_earth/colorsOfEarth/screens/home/components/wishlist.dart';
import 'package:colors_of_earth/colorsOfEarth/screens/home/controller/addToCartController.dart';
import 'package:colors_of_earth/colorsOfEarth/utils/constant/constant.dart';
import 'package:colors_of_earth/colorsOfEarth/utils/helper/api_helper.dart';
import 'package:colors_of_earth/colorsOfEarth/utils/shopify/shopify.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopify_flutter/models/src/product/product.dart';

import '../../../../utils/helper/db_helper.dart';

class ApiDetailScreen extends StatefulWidget {
  String id;

  ApiDetailScreen({super.key, required this.id});

  @override
  State<ApiDetailScreen> createState() => _ApiDetailScreenState();
}

class _ApiDetailScreenState extends State<ApiDetailScreen> {
  String productId = "";
  String currentSize = "";
  int currentVariantID = 0;
  int? selectedSizeIndex;
  int quantity = 1;
  bool isWishListed = false;

  AddToCartController addToCartController =
      Get.put(AddToCartController(), tag: 'addToCartController');

  final GlobalKey<ShakeWidgetState> shakeKey = GlobalKey<ShakeWidgetState>();

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  void initState() {
    productId = widget.id;
    DbHelper.dbHelper.checkAvailable(productId: productId).then((e) {
      setState(() {
        isWishListed = e;
      });
    });

    addToCartController.isExist.value = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    addToCartController.calculateCartLength();
    final Map<String, dynamic> finalVariant = {};

    void getFinalVariant(List variants, String variantTitle) {
      variants.forEach((e) {
        if (e['title'] == variantTitle) {
          finalVariant.addAll(e);
        }
      });
    }

    final AudioPlayer _audioPlayer = AudioPlayer();

    Future<void> _playSuccessSound() async {
      await _audioPlayer.setSource(AssetSource('sound/addToCart.mp3'));
      await _audioPlayer.resume(); // Play the sound
    }

    return FutureBuilder(
      future: ApiHelper.apiHelper.getProductById(productId),
      builder: (context, snapshot) {
        Map<String, dynamic> product = snapshot.data ?? {};
        if (snapshot.hasData) {
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
                "${product['title']}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                SizedBox(
                  width: width * 0.04,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Wishlist(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Cart(),
                      ),
                    );
                  },
                  child: badges.Badge(
                    badgeContent: Obx(
                      () => Text(
                        '${addToCartController.cartLength.value}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: Colors.black,
                    ),
                    position: badges.BadgePosition.topEnd(top: -10, end: -7),
                    child: Icon(Icons.shopping_bag_outlined),
                  ),
                  // child: Icon(
                  //   Icons.shopping_bag_outlined,
                  //   color: Colors.grey.shade700,
                  // ),
                ),
                SizedBox(
                  width: width * 0.04,
                ),
              ],
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(8),
              height: height * 0.08,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade200,
                  ),
                ),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      height: height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: const LineIcon.share(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (isWishListed == false) {
                          setState(() {
                            DbHelper.dbHelper
                                .insertProduct(
                                    productId: product['id'].toString())
                                .then((_) {
                              isWishListed = true;
                            });
                          });
                        } else {
                          setState(() {
                            DbHelper.dbHelper
                                .deleteProduct(product['id'].toString())
                                .then((_) {
                              isWishListed = false;
                            });
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Icon(
                          isWishListed == false
                              ? Icons.favorite_border
                              : Icons.favorite,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: GestureDetector(
                      onTap: () async {
                        addToCartController.calculateCartLength();
                        if (addToCartController
                            .checkProductExistInCart(currentVariantID)) {
                          Get.to(Cart());
                        } else {
                          if (currentSize == "") {
                            showModalBottomSheet(
                              showDragHandle: true,
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  width: width,
                                  child: StatefulBuilder(
                                    builder: (context, setState) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: height * 0.2,
                                                  width: width * 0.3,
                                                  child: FancyShimmerImage(
                                                    imageUrl: product['image']
                                                        ['src'],
                                                    shimmerBaseColor:
                                                        Colors.grey.shade300,
                                                    shimmerHighlightColor:
                                                        Colors.grey.shade100,
                                                    boxFit: BoxFit
                                                        .cover, // Fit image
                                                  ),
                                                ),
                                                SizedBox(width: width * 0.05),
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      width: width * 0.5,
                                                      child: Text(
                                                          "${product['title']}"),
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.02),
                                                    SizedBox(
                                                      width: width * 0.5,
                                                      child: Text(
                                                          "${product['id']}"),
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.02),
                                                    SizedBox(
                                                      width: width * 0.5,
                                                      child: Text(
                                                          "₹ ${product['variants'][0]['price']}"),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: height * 0.03),
                                            SizedBox(
                                              width: width * 0.85,
                                              child: Text(
                                                "Size : $currentSize",
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                            SizedBox(height: height * 0.015),
                                            SizedBox(
                                              height: height * 0.05,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: 5,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedSizeIndex =
                                                            index;
                                                        currentSize =
                                                            "${product['variants'][index]['title']}";
                                                        currentVariantID =
                                                            product['variants']
                                                                [index]['id'];
                                                      });
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      height: height * 0.3,
                                                      width: width * 0.1,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              selectedSizeIndex ==
                                                                      index
                                                                  ? Colors.black
                                                                  : Colors.grey,
                                                          width:
                                                              selectedSizeIndex ==
                                                                      index
                                                                  ? 2
                                                                  : 1,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "${product['variants'][index]['title']}",
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(height: height * 0.015),
                                            SizedBox(
                                              width: width * 0.85,
                                              child: const Text(
                                                "Please select Size to proceed",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: height * 0.02),
                                            GestureDetector(
                                              onTap: () {
                                                if (currentSize != "") {
                                                  getFinalVariant(
                                                      product['variants'],
                                                      currentSize);
                                                  product.addEntries([
                                                    const MapEntry(
                                                        'quantity', 1),
                                                    MapEntry('variant',
                                                        finalVariant),
                                                  ]);

                                                  if (!addToCartController
                                                      .checkProductExistInCart(
                                                          product['variant']
                                                              ['id'])) {
                                                    Get.snackbar("Success",
                                                        "Added to cart",
                                                        snackPosition:
                                                            SnackPosition.TOP,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    100));
                                                    _playSuccessSound();
                                                    addToCartController
                                                        .calculateCartLength();
                                                    Constant.cartProducts
                                                        .add(product);
                                                  } else {
                                                    addToCartController
                                                        .calculateCartLength();
                                                    Get.snackbar("Oops",
                                                        "Product already in cart",
                                                        snackPosition:
                                                            SnackPosition.TOP,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    10),
                                                        onTap: (_) {
                                                      Get.to(Cart());
                                                    });
                                                  }
                                                }
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.all(5),
                                                height: height * 0.05,
                                                decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Obx(
                                                  () => Text(
                                                    (addToCartController.isExist
                                                                .value ==
                                                            true)
                                                        ? "View Cart"
                                                        : "Add to cart",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            getFinalVariant(product['variants'], currentSize);
                            product.addEntries([
                              const MapEntry('quantity', 1),
                              MapEntry('variant', finalVariant),
                            ]);

                            if (!addToCartController.checkProductExistInCart(
                                product['variant']['id'])) {
                              Get.snackbar("Success", "Added to cart",
                                  snackPosition: SnackPosition.TOP);
                              _playSuccessSound();
                              Constant.cartProducts.add(product);
                            } else {
                              Get.snackbar("Oops", "Product already in cart",
                                  snackPosition: SnackPosition.TOP);
                            }
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(5),
                        height: height * 0.05,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ShakeMe(
                              // 4. pass the GlobalKey as an argument

                              // 5. configure the animation parameters
                              shakeCount: 3,
                              shakeOffset: 10,
                              shakeDuration: Duration(milliseconds: 500),
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.white,
                                size: 18,
                                weight: 0.5,
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Obx(
                              () => Text(
                                (addToCartController.isExist.value == true)
                                    ? "View Cart"
                                    : "Add to cart",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.65,
                    child: PageView.builder(
                      itemCount: product['images'].length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: height * 0.02,
                          width: width * 0.2,
                          child: FancyShimmerImage(
                            imageUrl: product['images'][index]['src'],
                            shimmerBaseColor: Colors.grey.shade300,
                            shimmerHighlightColor: Colors.grey.shade100,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * 0.37,
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.01,
                          ),
                          SizedBox(
                            width: width * 0.85,
                            child: Text(
                              "${product['title']}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          SizedBox(
                            width: width * 0.85,
                            child: Row(
                              children: [
                                Text(
                                  currentSize == ""
                                      ? "₹ ${product['variants'][0]['price']}"
                                      : "₹ ${product['variants'][selectedSizeIndex]['price']}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                                Text(
                                  currentSize == ""
                                      ? "${product['variants'][0]['compare_at_price']}"
                                      : "${product['variants'][selectedSizeIndex]['compare_at_price']}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          SizedBox(
                            width: width * 0.85,
                            child: Text(
                              "Size : ${(currentSize == "") ? 'select size' : currentSize}",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          SizedBox(
                            height: height * 0.06,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedSizeIndex = index;
                                          currentSize =
                                              "${product['variants'][index]['title']}";
                                          currentVariantID =
                                              product['variants'][index]['id'];
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        height: height * 0.06,
                                        width: width * 0.1,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: selectedSizeIndex == index
                                                ? Colors.black
                                                : Colors.grey,
                                            width: selectedSizeIndex == index
                                                ? 2
                                                : 1,
                                          ),
                                        ),
                                        child: Text(
                                          "${product['variants'][index]['title']}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            children: [
                              const Icon(
                                LineIcons.truck,
                                color: Colors.black,
                                size: 16,
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              const Text(
                                "Express Shipping",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.005,
                          ),
                          Row(
                            children: [
                              const Icon(
                                LineIcons.moneyBill,
                                color: Colors.black,
                                size: 16,
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              const Text(
                                "Cash on Delivery Available",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.005,
                          ),
                          Row(
                            children: [
                              const Icon(
                                LineIcons.shoppingBag,
                                color: Colors.black,
                                size: 16,
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              const Text(
                                "Easy 7 Days Return Policy",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "You may also like",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  SizedBox(
                    height: height * 0.42,
                    child: FutureBuilder(
                      future: Shopify.shopify.getRecomndedProduct(
                          product['admin_graphql_api_id'].toString()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Product product = snapshot.data![index];
                              return Column(
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
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 5),
                                      height: height * 0.28,
                                      width: width * 0.4,
                                      child: FancyShimmerImage(
                                        imageUrl: product.image,
                                        shimmerBaseColor: Colors.grey.shade300,
                                        shimmerHighlightColor:
                                            Colors.grey.shade100,
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
                                      product.title,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  SizedBox(
                                    width: width * 0.4,
                                    child: Text(
                                      "₹ ${product.price}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
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
                              return Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 5),
                                height: height * 0.25,
                                width: width * 0.4,
                                color: Colors.white,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
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
            title: const Text(
              "Loading...",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Wishlist()),
                  );
                },
                icon: const LineIcon.heart(),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Cart()),
                  );
                },
                icon: const LineIcon.shoppingBag(),
              ),
              SizedBox(
                width: width * 0.03,
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(8),
            height: height * 0.08,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                ),
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      height: height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      height: height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Shimmer.fromColors(
                    baseColor: Colors.black45,
                    highlightColor: Colors.black26,
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(5),
                      height: height * 0.05,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: height * 0.65,
                  width: width,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
