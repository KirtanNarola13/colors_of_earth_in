import 'dart:developer';

import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colors_of_earth/colorsOfEarth/screens/home/components/apiDetailScreen/api_detail_screen.dart';
import 'package:colors_of_earth/colorsOfEarth/screens/home/components/cart.dart';
import 'package:colors_of_earth/colorsOfEarth/screens/home/controller/addToCartController.dart';
import 'package:colors_of_earth/colorsOfEarth/utils/helper/api_helper.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopify_flutter/models/src/product/product.dart';

import '../../constant/constant.dart';
import '../../utils/helper/firestore_helper.dart';
import '../../utils/shopify/shopify.dart';
import '../new/view_collection_product/view_collection_product.dart';
import 'components/search/search.dart';
import 'components/view_all/explore_products.dart';
import 'components/view_all/new_launched_view.dart';
import 'components/wishlist.dart';
import 'controller/bannerIndexController.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

initRemoteConfig() {
  Constants.instance.remoteConfig = FirebaseRemoteConfig.instance;
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController bannerPageController;

  BannerIndexController bannerIndexController =
      Get.put(BannerIndexController());
  AddToCartController addToCartController = Get.put(AddToCartController());
  @override
  void initState() {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize('088cb45d-7d0a-4b81-ba27-b976cca037a7');
    OneSignal.Notifications.requestPermission(true);
    bannerPageController = PageController(initialPage: 0);
    FirestoreHelper.firestoreHelper.addCollection();
    OneSignal.Notifications.addClickListener((event) {
      if (event.notification.additionalData!.containsKey("Product")) {
        // Retrieve the product and collection IDs from the notification data
        var product = event.notification.additionalData!["Product"].toString();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApiDetailScreen(id: product),
          ),
        );
      } else if (event.notification.additionalData!.containsKey("Collection")) {
        var collection =
            event.notification.additionalData!["Collection"].toString();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewCollectionProduct(
              id: collection,
              name: "Explore Product",
            ),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    addToCartController.calculateCartLength();
    // Logger logger = Logger();
    return FutureBuilder(
      future: ApiHelper.apiHelper.getShopDetail(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        } else if (snapshot.hasData) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: height * 0.065,
                backgroundColor: Colors.white,
                title: Container(
                  width: width * 0.35,
                  height: height * 0.04,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Image(
                    image: AssetImage(
                      "assets/colorsOfEarthLogo.png" ?? "",
                    ),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Search(),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.search,
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
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "# Shop 🛍️ by Collection",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //todo :  Category's Row
                    Center(
                      child: SizedBox(
                        height: height * 0.25,
                        child: StreamBuilder(
                          stream:
                              FirestoreHelper.firestoreHelper.getCollection(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  snapshot.error.toString(),
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasData) {
                              return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  List<
                                          QueryDocumentSnapshot<
                                              Map<String, dynamic>>>?
                                      collection = snapshot.data!.docs;

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ViewCollectionProduct(
                                            id: collection[index]['id']
                                                .split('/')
                                                .last,
                                            name: collection[index]['title'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Image Container with subtle shadow
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          height: height * 0.18,
                                          width: width * 0.25,
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .white, // White background
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                    0.05), // Subtle shadow
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                                offset: const Offset(
                                                    0, 2), // Slight elevation
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            child: FutureBuilder(
                                              future: ApiHelper.apiHelper
                                                  .getProductFromCollection(
                                                collection[index]['id']
                                                    .split('/')
                                                    .last,
                                              ),
                                              builder: (context, snapshot) {
                                                List? data = snapshot.data;
                                                if (snapshot.hasData) {
                                                  return FancyShimmerImage(
                                                    imageUrl: data!.isNotEmpty
                                                        ? data.first['image']
                                                            ['src']
                                                        : "",
                                                    shimmerBaseColor:
                                                        Colors.grey.shade300,
                                                    shimmerHighlightColor:
                                                        Colors.grey.shade100,
                                                    boxFit: BoxFit
                                                        .cover, // Fit image
                                                  );
                                                }
                                                return Container();
                                              },
                                            ),
                                          ),
                                        ),
                                        // Title Text with classic font and subtle color
                                        SizedBox(
                                          width: width * 0.25,
                                          child: Text(
                                            collection[index]['title'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight
                                                  .bold, // Slightly bold
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }

                            // Placeholder while loading
                            return ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(
                                      top: 20, bottom: 40),
                                  alignment: Alignment.bottomRight,
                                  height: height * 0.15,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.grey.shade100, // Soft background
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    //todo: Collection Banner
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: height * 0.2,
                          child: FutureBuilder(
                            future: Shopify.shopify.getCollection(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return CarouselSlider(
                                  options: CarouselOptions(
                                      height: height * 0.65,
                                      autoPlay: true,
                                      viewportFraction: 1,
                                      enableInfiniteScroll: true,
                                      onPageChanged: (index, reason) {
                                        bannerIndexController
                                            .changeBannerIndex(index);
                                      }),
                                  items: homeBanner.map((i) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: height * 0.6,
                                          width: width,
                                          child: FancyShimmerImage(
                                            imageUrl: i,
                                            shimmerBaseColor:
                                                Colors.grey.shade300,
                                            shimmerHighlightColor:
                                                Colors.grey.shade100,
                                            boxFit: BoxFit.cover, // Fit image
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                );
                              }

                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                enabled: true,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: height * 0.25,
                                      width: width,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          height: height * 0.01,
                          width: width * 0.2,
                          child: ListView.builder(
                            itemCount: 3,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Obx(
                                () => Container(
                                  width: index ==
                                          bannerIndexController
                                              .bannerIndex.value
                                      ? width * 0.1
                                      : width *
                                          0.03, // Observe the value here with .value
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: index ==
                                            bannerIndexController
                                                .bannerIndex.value
                                        ? Colors.black
                                        : Colors
                                            .grey, // Observe the value here with .value
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: height * 0.04,
                    ),
                    //todo: New Launched Text
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "# New Launched",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
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
                                Map<String, dynamic>? product =
                                    snapshot.data?[index];
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ApiDetailScreen(
                                                    id: product['id']
                                                        .toString()),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 5),
                                        height: height * 0.3,
                                        width: width * 0.41,
                                        child: FancyShimmerImage(
                                          imageUrl:
                                              "${product!['image']['src']}",
                                          shimmerBaseColor:
                                              Colors.grey.shade300,
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
                                        "${product['title']}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
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
                                Map<String, dynamic>? product =
                                    snapshot.data?[index];
                                return Container(
                                  margin:
                                      const EdgeInsets.only(left: 10, right: 5),
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
                    SizedBox(
                      height: height * 0.025,
                    ),
                    //todo: View All Container
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NewLaunchedView()));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: height * 0.04,
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: const Text(
                            "VIEW ALL",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    //todo: Collection Banner
                    Container(
                      height: height * 0.22,
                      width: width,
                      child: FancyShimmerImage(
                        imageUrl: Constants.instance.remoteConfig
                                ?.getString('middle_banner') ??
                            homeBanner[0],
                        shimmerBaseColor: Colors.grey.shade300,
                        shimmerHighlightColor: Colors.grey.shade100,
                        boxFit: BoxFit.cover, // Fit image
                      ),
                    ),
                    SizedBox(
                      height: height * 0.035,
                    ),
                    //todo: Explore Text
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "# Explore",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.025,
                    ),
                    //todo: Explore Products List
                    SizedBox(
                      height: height * 0.36,
                      child: FutureBuilder(
                        future: Shopify.shopify.get8Product(),
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
                                        log(product.id);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ApiDetailScreen(
                                                    id: product.id
                                                        .split('/')
                                                        .last),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 5),
                                        height: height * 0.25,
                                        width: width * 0.4,
                                        child: FancyShimmerImage(
                                          imageUrl: product.image,
                                          shimmerBaseColor:
                                              Colors.grey.shade300,
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
                                          fontSize: 12,
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
                                          fontSize: 13,
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
                    SizedBox(
                      height: height * 0.02,
                    ),
                    //todo: View All Container
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ExploreProducts()));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: height * 0.04,
                          width: width * 0.2,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: const Text(
                            "VIEW ALL",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.035,
                    ),

                    //todo: Collection Banner
                    Container(
                      height: height * 0.15,
                      width: width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            Constants.instance.remoteConfig
                                    ?.getString('bottom_banner') ??
                                homeBanner[0],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(60.0),
            child: Image(
              image: AssetImage('assets/colorsOfEarthLogo.png'),
            ),
          ),
        );
        // return Scaffold(
        //   body: SingleChildScrollView(
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         SizedBox(
        //           height: height * 0.1,
        //         ),
        //         SizedBox(
        //           height: height * 0.18,
        //           child: Shimmer.fromColors(
        //             baseColor: Colors.grey.shade300,
        //             highlightColor: Colors.grey.shade100,
        //             enabled: true,
        //             child: ListView.builder(
        //               scrollDirection: Axis.horizontal,
        //               itemCount: 5,
        //               itemBuilder: (context, index) {
        //                 return Container(
        //                   margin: const EdgeInsets.only(left: 10, right: 5),
        //                   color: Colors.white,
        //                   height: height * 0.1,
        //                   width: width * 0.28,
        //                 );
        //               },
        //             ),
        //           ),
        //         ),
        //
        //         SizedBox(
        //           height: height * 0.02,
        //         ),
        //
        //         //todo: Collection Banner
        //         SizedBox(
        //           height: height * 0.2,
        //           child: Shimmer.fromColors(
        //             baseColor: Colors.grey.shade300,
        //             highlightColor: Colors.grey.shade100,
        //             enabled: true,
        //             child: ListView.builder(
        //               scrollDirection: Axis.horizontal,
        //               physics: const NeverScrollableScrollPhysics(),
        //               itemCount: 1,
        //               itemBuilder: (context, index) {
        //                 return Container(
        //                   height: height * 0.25,
        //                   width: width,
        //                   color: Colors.white,
        //                 );
        //               },
        //             ),
        //           ),
        //         ),
        //
        //         SizedBox(
        //           height: height * 0.03,
        //         ),
        //         //todo: New Launched
        //         SizedBox(
        //           height: height * 0.36,
        //           child: Shimmer.fromColors(
        //             baseColor: Colors.grey.shade300,
        //             highlightColor: Colors.grey.shade100,
        //             enabled: true,
        //             child: ListView.builder(
        //               scrollDirection: Axis.horizontal,
        //               itemCount: 5,
        //               itemBuilder: (context, index) {
        //                 return Container(
        //                   margin: const EdgeInsets.only(left: 10, right: 5),
        //                   color: Colors.white,
        //                   height: height * 0.3,
        //                   width: width * 0.41,
        //                 );
        //               },
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // );
      },
    );
  }
}

List homeBanner = [
  Constants.instance.remoteConfig?.getString('trending_banner_0'),
  Constants.instance.remoteConfig?.getString('trending_banner_1'),
  Constants.instance.remoteConfig?.getString('trending_banner_2'),
];
