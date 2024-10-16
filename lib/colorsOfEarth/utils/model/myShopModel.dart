class MyShopModel {
  int? id;
  String? name;
  String? email;
  String? domain;
  String? province;
  String? country;
  String? address1;
  String? zip;
  String? city;
  String? phone;
  String? address2;
  String? countryCode;
  String? countryName;
  String? currency;
  String? customerEmail;
  String? shopOwner;
  String? weightUnit;
  String? provinceCode;
  String? myshopifyDomain;
  int? primaryLocationId;

  MyShopModel({
    required this.id,
    required this.name,
    required this.email,
    required this.domain,
    required this.province,
    required this.country,
    required this.address1,
    required this.zip,
    required this.city,
    required this.phone,
    required this.address2,
    required this.countryCode,
    required this.countryName,
    required this.currency,
    required this.customerEmail,
    required this.shopOwner,
    required this.weightUnit,
    required this.provinceCode,
    required this.myshopifyDomain,
    required this.primaryLocationId,
  });
  factory MyShopModel.fromJson(Map json) => MyShopModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        domain: json["domain"],
        province: json["province"],
        country: json["country"],
        address1: json["address1"],
        zip: json["zip"],
        city: json["city"],
        phone: json["phone"],
        address2: json["address2"],
        countryCode: json["country_code"],
        countryName: json["country_name"],
        currency: json["currency"],
        customerEmail: json["customer_email"],
        shopOwner: json["shop_owner"],
        weightUnit: json["weight_unit"],
        provinceCode: json["province_code"],
        myshopifyDomain: json["myshopify_domain"],
        primaryLocationId: json["primary_location_id"],
      );
}
