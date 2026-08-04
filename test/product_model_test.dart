import 'package:flutter_test/flutter_test.dart';
import 'package:menu/model/menu_product_model.dart';

void main() {
  group('Product Model Tests', () {
    test('fromJson handles missing highlight_product', () {
      final json = {
        "id": 1,
        "name": "Test Product",
        "price": "100.00",
      };
      final product = Product.fromJson(json);
      expect(product.highlightProduct, isFalse);
    });

    test('fromJson handles null highlight_product', () {
      final json = {
        "id": 1,
        "name": "Test Product",
        "price": "100.00",
        "highlight_product": null,
      };
      final product = Product.fromJson(json);
      expect(product.highlightProduct, isFalse);
    });

    test('fromJson parses boolean true/false', () {
      final jsonTrue = {"highlight_product": true};
      final jsonFalse = {"highlight_product": false};

      expect(Product.fromJson(jsonTrue).highlightProduct, isTrue);
      expect(Product.fromJson(jsonFalse).highlightProduct, isFalse);
    });

    test('fromJson parses integer 1/0', () {
      final jsonTrue = {"highlight_product": 1};
      final jsonFalse = {"highlight_product": 0};

      expect(Product.fromJson(jsonTrue).highlightProduct, isTrue);
      expect(Product.fromJson(jsonFalse).highlightProduct, isFalse);
    });

    test('fromJson parses string true/false/1/0', () {
      final jsonTrueStr = {"highlight_product": "true"};
      final jsonTrueNumStr = {"highlight_product": "1"};
      final jsonFalseStr = {"highlight_product": "false"};
      final jsonFalseNumStr = {"highlight_product": "0"};

      expect(Product.fromJson(jsonTrueStr).highlightProduct, isTrue);
      expect(Product.fromJson(jsonTrueNumStr).highlightProduct, isTrue);
      expect(Product.fromJson(jsonFalseStr).highlightProduct, isFalse);
      expect(Product.fromJson(jsonFalseNumStr).highlightProduct, isFalse);
    });

    test('toJson encodes highlightProduct correctly', () {
      final product = Product(id: 1, highlightProduct: true);
      final json = product.toJson();
      expect(json['highlight_product'], isTrue);
    });
  });
}
