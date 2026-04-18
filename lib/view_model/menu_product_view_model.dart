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
      if (event is Map && event['type'] == 'price_updated') {
        final productId = event['product_id'];
        final newPrice = event['new_price']?.toString();
        final menuPrice = event['menu_price']?.toString();

        if (productId != null && newPrice != null && menuPrice != null) {
          _updateProductPrice(productId, newPrice, menuPrice);
        }
      }

      /// 🚨 Market crash
      if (event is Map && event['type'] == 'market_crashed') {
        if (!_isCrashShown) {
          _isCrashShown = true;
          onMarketCrashed?.call();
        }
      }
    });
  }

  void resetCrash() {
    _isCrashShown = false;
  }

  void _updateProductPrice(dynamic productId, String newPrice, String menuPrice) {
    final int targetId = productId is int
        ? productId
        : int.tryParse(productId.toString()) ?? -1;

    if (targetId == -1) return;

    bool updated = false;

    if (_menuProduct?.data != null) {
      for (var category in _menuProduct!.data!) {
        for (var product in category.products ?? []) {
          if (product.id == targetId) {
            product.price = newPrice;
            product.menuPrice = menuPrice;
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