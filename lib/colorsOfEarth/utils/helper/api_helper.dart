import 'dart:convert';
import 'dart:developer';

import 'package:colors_of_earth/colorsOfEarth/screens/order/const/const.dart';
import 'package:colors_of_earth/colorsOfEarth/utils/model/myShopModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constant.dart';

class ApiHelper {
  ApiHelper._();
  static final ApiHelper apiHelper = ApiHelper._();
  static final List collection = [];
  static Map<String, dynamic> user = {};

  //todo: Get Shop Detail
  Future<MyShopModel?> getShopDetail() async {
    try {
      String api = "https://colorsofearth.in/admin/api/2021-07/shop.json";
      http.Response response = await http.get(
        Uri.parse(api),
        headers: {
          'X-Shopify-Access-Token': Constant.apiAccessToken,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        MyShopModel myShopModel = MyShopModel.fromJson(data['shop']);
        return myShopModel;
      }
    } catch (e) {
      Get.snackbar('Error', 'Oops, something went wrong');

      log('Error in getShopDetail: $e');
    }
    return null;
  }

  //todo: Get New Launch Products
  Future<List?> getNewLaunchedProducts() async {
    try {
      String api =
          "https://colorsofearth.in//admin/api/2023-10/collections/331453595801/products.json";
      http.Response response = await http.get(
        Uri.parse(api),
        headers: {
          'X-Shopify-Access-Token': Constant.apiAccessToken,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data['products'];
      }
    } catch (e) {
      Get.snackbar('Error', 'Oops, something went wrong');
      log('Error in getNewLaunchedProducts: $e');
    }
    return null;
  }

  //todo: Get Product From Collection Id
  Future<List?> getProductFromCollection(String id) async {
    try {
      String api =
          "https://colorsofearth.in//admin/api/2023-10/collections/$id/products.json";
      http.Response response = await http.get(
        Uri.parse(api),
        headers: {
          'X-Shopify-Access-Token': Constant.apiAccessToken,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data['products'];
      }
    } catch (e) {
      Get.snackbar('Error', 'Oops, something went wrong');
      log('Error in getProductFromCollection: $e');
    }
    return null;
  }

  //todo: Get Product By Id
  Future<Map<String, dynamic>?> getProductById(String id) async {
    try {
      String api =
          "https://colorsofearth.in/admin/api/2024-07/products/$id.json";
      http.Response response = await http.get(
        Uri.parse(api),
        headers: {
          'X-Shopify-Access-Token': Constant.apiAccessToken,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data['product'];
      }
    } catch (e) {
      Get.snackbar('Error', 'Oops, something went wrong');
      log('Error in getProductById: $e');
    }
    return null;
  }

  //todo: Create Checkout
  Future<Map<String, dynamic>?> createCheckout(List<Map> item) async {
    try {
      const url = 'https://colorsofearth.in/api/2023-01/graphql.json';
      final accessToken = Constant.storefrontAccessToken;
      final List<Map<String, dynamic>> lineItems = [];

      for (int i = 0; i < item.length; i++) {
        lineItems.add({
          'variantId': "gid://shopify/ProductVariant/${item[i]['id']}",
          'quantity': item[i]['quantity']
        });
      }

      if (lineItems.isNotEmpty) {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'X-Shopify-Storefront-Access-Token': accessToken,
          },
          body: jsonEncode({
            'query': '''
          mutation {
            checkoutCreate(input: {
              lineItems: ${lineItems.map((item) => '''
              {
                variantId: "${item['variantId']}"
                quantity: ${item['quantity']}
              }
              ''').toList()}
            }) {
              checkout {
                id
                webUrl
              }
              userErrors {
                field
                message
              }
            }
          }
          '''
          }),
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print(
              'Checkout created: ${data['data']['checkoutCreate']['checkout']['webUrl']} =====================\n${jsonEncode(data)}');
          return data;
        } else {
          print('Failed to create checkout: ${response.statusCode}');
          print(response.body);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Oops, something went wrong');

      log('Error in createCheckout: $e');
    }
    return null;
  }

  //todo: Search Customer With Email
  searchCustomerWithEmail(String email) async {
    try {
      String url =
          "https://colorsofearth.in/admin/api/2023-07/customers/search.json?query=email:$email";
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'X-Shopify-Access-Token': Constant.apiAccessToken,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        user = data['customers'][0];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('customerId', '${user['id']}');
        customerId = prefs.getString('customerId');
      } else {
        log('Failed to search customer: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Oops, something went wrong');
      log('Error in searchCustomerWithEmail: $e');
    }
  }

  //todo: Create Customer Access Token
  createCustomerAccessToken(String email, String password) async {
    try {
      const url = 'https://colorsofearth.in/api/2024-07/graphql.json';
      final accessToken = Constant.storefrontAccessToken;

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'X-Shopify-Storefront-Access-Token': accessToken,
        },
        body: jsonEncode({
          'query': '''
        mutation customerAccessTokenCreate { customerAccessTokenCreate(input: {email: \"$email\", password: \"$password\"}) { customerAccessToken { accessToken } customerUserErrors { message } } }
        '''
        }),
      );

      var data = jsonDecode(response.body);
      if (response.statusCode == 200 &&
          data['data']['customerAccessTokenCreate']['customerAccessToken']
                  ['accessToken'] !=
              null) {
        await searchCustomerWithEmail(email);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token',
            '${data['data']['customerAccessTokenCreate']['customerAccessToken']['accessToken']}');
        token = prefs.getString('token');
        return data['data']['customerAccessTokenCreate']['customerAccessToken']
            ['accessToken'];
      } else {
        print(
            'Failed to create token: ${data['data']['customerAccessTokenCreate']['customerUserErrors']}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Oops, something went wrong');
      log('Error in createCustomerAccessToken: $e');
    }
    return null;
  }

  //todo: Get User Order
  Future<String?> getOrder() async {
    try {
      String api =
          "https://colorsofearth.in/admin/api/2024-01/customers/$customerId/orders.json";
      http.Response response = await http.get(Uri.parse(api), headers: {
        'X-Shopify-Access-Token': Constant.apiAccessToken,
      });
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      Get.snackbar('Error', 'Oops, something went wrong');
      log('Error in getOrder: $e');
    }
    return null;
  }
}
