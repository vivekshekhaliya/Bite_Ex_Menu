class AppUrl {
  /// Base api url

  static var baseUrl = 'https://site.biteexchange.com/api';

  // static var baseUrl = 'https://stage.biteexchange.com/api';
  static const String razorpayKeyId = String.fromEnvironment(
    'RAZORPAY_KEY_ID',
    defaultValue: 'rzp_test_SUBQPzomKFpTPX',
  );
  static var socketUrl = 'wss://site.biteexchange.com/app/local';

  /// Auth flow api url

  static var signInUrl = '$baseUrl/tv-login';

  /// Product flow api url

  static var productUrl = '$baseUrl/get-products-for-tv';
}
