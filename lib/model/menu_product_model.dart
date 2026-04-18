// To parse this JSON data, do
//
//     final menuProduct = menuProductFromJson(jsonString);

import 'dart:convert';

MenuProduct menuProductFromJson(String str) =>
    MenuProduct.fromJson(json.decode(str));

String menuProductToJson(MenuProduct data) => json.encode(data.toJson());

class MenuProduct {
  bool? success;
  String? page;
  List<Datum>? data;
  String? message;

  MenuProduct({this.success, this.page, this.data, this.message});

  factory MenuProduct.fromJson(Map<String, dynamic> json) => MenuProduct(
    success: json["success"],
    page: json["page"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "page": page,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  int? id;
  String? name;
  List<Product>? products;

  Datum({this.id, this.name, this.products});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    products: json["products"] == null
        ? []
        : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "products": products == null
        ? []
        : List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}

class Product {
  int? id;
  String? name;
  String? price;
  String? menuPrice;
  String? image;
  int? categoryId;
  int? isAvailable;
  String? stock;
  Product({
    this.id,
    this.name,
    this.price,
    this.menuPrice,
    this.image,
    this.categoryId,
    this.isAvailable,
    this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    menuPrice: json["menu_price"],
    image: json["image"],
    categoryId: json["category_id"],
    isAvailable: json["is_available"],
    stock: json['stock'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "menu_price": menuPrice,
    "image": image,
    "category_id": categoryId,
    "is_available": isAvailable,
    "stock": stock,
  };
}
