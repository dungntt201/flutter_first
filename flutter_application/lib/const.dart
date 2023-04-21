class Contant {
  static const mapLanguage = {'Tiếng Việt': 'vn', 'English': 'en'};

  static const mapOrderType = {
    'Nạp tiền điện thoại': 'topup',
    'Thanh toán hoá đơn': 'billpayment',
    'Thời trang': 'fashion'
  };

  static const mapBank = {
    'Không chọn': null,
    'Ung dung MobileBanking': 'MBAPP',
    'VNPAYQR': 'VNPAYQR',
    'LOCAL BANK': 'VNBANK',
    'INTERNET BANKING': 'IB',
    'Ngan hang NCB': 'NCB',
    'Ngan hang ACB': 'ACB',
    'Ngan hang SHB': 'SHB'
  };

  // vnp config
  static const vnpPayUrl = 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html';
  static const vnpReturnurl = 'http://localhost:9090/home/returnURL';
  static const vnpTmnCode = 'HK3Q7GGZ';
  static const vnpApiUrl =
      'https://sandbox.vnpayment.vn/merchant_webapi/merchant.html';
  static const vnpHashSecret = 'TRQTIFFSYPZUQCLXRCBRTLOTAVTISNYX';
}
