import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:menu/model/menu_product_model.dart';
import 'package:menu/repository/menu_product_repository.dart';
import 'package:menu/services/web_socket_manager.dart';
import '../res/constants/toast_message.dart';

class MenuProductViewModel with ChangeNotifier {
  StreamSubscription? _socketSubscription;

  /// 🔥 Callback for market crash event
  VoidCallback? onMarketCrashed;

  bool _isCrashShown = false; // ✅ prevent multiple popup

  bool getMenuProductLoading = false;
  bool get loading => getMenuProductLoading;

  MenuProduct? _menuProduct;
  MenuProduct? get banner => _menuProduct;

  void setLoading(bool val) {
    getMenuProductLoading = val;
    notifyListeners();
  }

  /// 🔥 SIMPLE API CALL WITH PAGE
  Future<void> getBannerApi(BuildContext context, {int page = 1}) async {
    setLoading(true);

    try {
      final response =
      await MenuProductRepository.getMenuProduct(page: page);

      _menuProduct = MenuProduct.fromJson(response);

      setLoading(false);
    } catch (e) {
      setLoading(false);
      ToastMessage.cherryMessage(context, '$e', ToastType.error);
    }
  }

  /// 🔌 SOCKET (same)
  void startSocketListener() {
    _socketSubscription?.cancel();

    _socketSubscription = WebSocketManager().stream.listen((event) {
      if (event is Map) {
        if (event['type'] == 'price_updated') {
          final productId = event['product_id'];
          final newPrice = event['new_price']?.toString();
          final menuPrice = event['menu_price']?.toString();
          final stock = event['stock']?.toString(); // 📦 stock comes with price
          final priceColor = event['price_color']?.toString();
          final highlightProduct = event['highlight_product'];

          if (productId != null) {
            _updateProduct(
              productId,
              newPrice: newPrice,
              menuPrice: menuPrice,
              stock: stock,
              priceColor: priceColor,
              highlightProduct: highlightProduct,
            );
          }
        } else if (event['type'] == 'highlight_updated') {
          final productId = event['product_id'];
          final highlightProduct = event['highlight_product'];

          if (productId != null) {
            _updateProduct(
              productId,
              highlightProduct: highlightProduct,
            );
          }
        }

        /// 🚨 Market crash
        if (event['type'] == 'market_crashed') {
          if (!_isCrashShown) {
            _isCrashShown = true;
            onMarketCrashed?.call();
          }
        }
      }
    });
  }

  void resetCrash() {
    _isCrashShown = false;
  }


  void _updateProduct(
    dynamic productId, {
    String? newPrice,
    String? menuPrice,
    String? stock,
    String? priceColor,
    dynamic highlightProduct,
  }) {
    final int targetId = productId is int
        ? productId
        : int.tryParse(productId.toString()) ?? -1;

    if (targetId == -1) return;

    bool updated = false;

    if (_menuProduct?.data != null) {
      for (var category in _menuProduct!.data!) {
        for (var product in category.products ?? []) {
          if (product.id == targetId) {
            if (newPrice != null) product.price = newPrice;
            if (menuPrice != null) product.menuPrice = menuPrice;
            if (priceColor != null) product.priceColor = priceColor;
            if (stock != null) product.stock = stock;
            if (highlightProduct != null) {
              product.highlightProduct = highlightProduct is bool
                  ? highlightProduct
                  : (highlightProduct == 1 ||
                      highlightProduct == '1' ||
                      highlightProduct.toString().toLowerCase() == 'true');
            }
            updated = true;
          }
        }
      }
    }

    if (updated) notifyListeners();
  }

  void disposeSocket() {
    _socketSubscription?.cancel();
  }
}