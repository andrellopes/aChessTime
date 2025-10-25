// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseService extends ChangeNotifier {
  static const String _kProVersionId = 'pro_chess_time';
  static const String _kPurchaseStatusKey = 'pro_version_purchased';
  
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  bool _isAvailable = false;
  bool _isPurchasing = false;
  bool _isProVersion = false;
  List<ProductDetails> _products = [];
  String _purchaseError = '';

  // Function to get localized strings (will be defined by the widget that uses the service)
  String Function()? _getLocalizedProductNotFound;
  String Function()? _getLocalizedPurchaseError;

  bool get isAvailable => _isAvailable;
  bool get isPurchasing => _isPurchasing;
  bool get isProVersion => _isProVersion;
  List<ProductDetails> get products => _products;
  String get purchaseError => _purchaseError;
  String get proVersionId => _kProVersionId;

  PurchaseService() {
    _initialize();
  }

  Future<void> _initialize() async {
    // FIRST: Load persisted status from SharedPreferences
    await _loadPurchaseStatus();
    
    // Check if service is available
    _isAvailable = await _inAppPurchase.isAvailable();
    
    if (_isAvailable) {
      // Configure listener for purchases
      final Stream<List<PurchaseDetails>> purchaseStream = _inAppPurchase.purchaseStream;
      _subscription = purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () => _subscription.cancel(),
        onError: (error) => debugPrint('Purchase stream error: $error'),
      );
      
      // Initialize for iOS if necessary
      if (Platform.isIOS) {
        final InAppPurchaseStoreKitPlatformAddition iosAddition =
            _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosAddition.setDelegate(ExamplePaymentQueueDelegate());
      }

      // Load products
      await _loadProducts();
      
      // Check pending purchases (but does not overwrite already persisted status)
      await _restorePurchases();
    }
    
    notifyListeners();
  }

  Future<void> _loadProducts() async {
    if (!_isAvailable) return;

    const Set<String> identifiers = {_kProVersionId};
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(identifiers);
    
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found: ${response.notFoundIDs}');
    }
    
    _products = response.productDetails;
    notifyListeners();
  }

  Future<void> _loadPurchaseStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isProVersion = prefs.getBool(_kPurchaseStatusKey) ?? false;
    notifyListeners();
  }

  Future<void> _savePurchaseStatus(bool isPro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPurchaseStatusKey, isPro);
    _isProVersion = isPro;
    notifyListeners();
  }

  // Method to define localization functions
  void setLocalizationFunctions({
    String Function()? getLocalizedProductNotFound,
    String Function()? getLocalizedPurchaseError,
  }) {
    _getLocalizedProductNotFound = getLocalizedProductNotFound;
    _getLocalizedPurchaseError = getLocalizedPurchaseError;
  }

  Future<void> buyProVersion() async {
    if (!_isAvailable || _isPurchasing) return;

    final ProductDetails? productDetails = _products
        .where((product) => product.id == _kProVersionId)
        .firstOrNull;

    if (productDetails == null) {
      _purchaseError = _getLocalizedProductNotFound?.call() ?? 'Product not found';
      notifyListeners();
      return;
    }

    _isPurchasing = true;
    _purchaseError = '';
    notifyListeners();

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> _restorePurchases() async {
    if (!_isAvailable) return;

    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      _handlePurchase(purchaseDetails);
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == _kProVersionId) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _savePurchaseStatus(true);
          _isPurchasing = false;
          _purchaseError = '';
          break;
        case PurchaseStatus.error:
          _isPurchasing = false;
          _purchaseError = purchaseDetails.error?.message ?? (_getLocalizedPurchaseError?.call() ?? 'Purchase error');
          await _savePurchaseStatus(false);
          break;
        case PurchaseStatus.pending:
          _isPurchasing = true;
          _purchaseError = '';
          break;
        case PurchaseStatus.canceled:
          _isPurchasing = false;
          _purchaseError = '';
          break;
      }
    }

    if (purchaseDetails.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchaseDetails);
    }

    notifyListeners();
  }

  ProductDetails? getProVersionProduct() {
    return _products.where((product) => product.id == _kProVersionId).firstOrNull;
  }

  Future<void> restorePurchases() async {
    await _restorePurchases();
  }

  // Debug method: force Pro status
  void setDebugPro(bool isPro) {
    _savePurchaseStatus(isPro);
  }

  // METHODS FOR BACKUP AND RESTORATION

  Map<String, dynamic> getBackupData() {
    return {
      'isProVersion': isProVersion,
      'purchaseDate': DateTime.now().toIso8601String(),
    };
  }

  Future<void> restoreFromBackup(Map<String, dynamic> backupData) async {
    final isPro = backupData['isProVersion'] ?? false;
    await _savePurchaseStatus(isPro);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
