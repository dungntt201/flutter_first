import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/web_view.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:intl/intl.dart';

import 'const.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _fromKey = GlobalKey<FormState>();

  final _listOrderType = Contant.mapOrderType.keys.toList();
  String? _selectedOrderType = Contant.mapOrderType.keys.toList().first;
  final _listBank = Contant.mapBank.keys.toList();
  String? _selectedBank = Contant.mapBank.keys.toList().first;
  final _listLang = Contant.mapLanguage.keys.toList();
  String? _selectedLang = Contant.mapLanguage.keys.toList().first;

  final TextEditingController _amountValue = TextEditingController();
  final TextEditingController _orderInfoValue = TextEditingController();

  @override
  void initState() {
    var now = DateTime.now();
    var formatterDate = DateFormat('dd-MM-yyyy HH:mm:ss');
    _amountValue.text = "10000"; //default amount value
    _orderInfoValue.text =
        "Thanh toan don hang thoi gian: ${formatterDate.format(now)}"; //default order info value
    super.initState();
  }

  static const platform = MethodChannel('paymentGateway');

  Future<void> _openSDK(url, tmnCode) async {
    // try {
    //   await platform.invokeMethod('openSDK', {'url': url, 'tmnCode': tmnCode});
    // } on PlatformException catch (e) {
    //   print("Failed");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("VNPAY DEMO"),
          centerTitle: true
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
              key: _fromKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: const Text(
                      'Tạo mới đơn hàng',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: DropdownButtonFormField(
                      value: _selectedOrderType,
                      items: _listOrderType
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedOrderType = value;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.blue,
                      ),
                      decoration: InputDecoration(
                          labelText: "Loại hàng hoá",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: TextFormField(
                      controller: _amountValue,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: const TextStyle(fontSize: 16),
                      validator: (value) {
                        if (value != null && value.length < 5 ||
                            value != null &&
                                value.startsWith('0') &&
                                value.length < 6) {
                          return 'Số tiền tối thiểu 10,000';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Số tiền",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: TextFormField(
                      controller: _orderInfoValue,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 16),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Nhập nội dung thanh toán';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Nội dung thanh toán",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: DropdownButtonFormField(
                      value: _selectedBank,
                      items: _listBank
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBank = value;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.blue,
                      ),
                      decoration: InputDecoration(
                          labelText: "Ngân hàng",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: DropdownButtonFormField(
                      value: _selectedLang,
                      items: _listLang
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLang = value;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.blue,
                      ),
                      decoration: InputDecoration(
                          labelText: "Ngôn ngữ",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_fromKey.currentState!.validate()) {
                          _getIpAddress().then((value) {
                            String response = handle(
                                _amountValue.text,
                                _selectedOrderType,
                                _orderInfoValue.text,
                                _selectedBank!,
                                _selectedLang!,
                                value);
                          // _openSDK(response, Contant.vnpTmnCode);
                            _handleURLButtonPress(context, response);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.blue[400],
                          padding: const EdgeInsets.symmetric(vertical: 10)),
                      child: const Text(
                        "Thanh toán Redirect",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

void _handleURLButtonPress(BuildContext context, String url) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => WebViewPage(url)));
  // context,
  // MaterialPageRoute(builder: (context) => WebViewEx4(url)));
}

_getIpAddress() async {
  try {
    var ipAddress = IpAddress();
    dynamic data = await ipAddress.getIpAddress();
    return data;
  } on IpAddressException catch (exception) {
    print(exception.message);
    return null;
  }
}

String handle(String amount, String? orderType, String orderInfo,
    String bankCode, String locate, String ipAddress) {
  String vnpVersion = '2.1.0';
  String vnpCommand = 'pay';
  String vnpTxnRef = '101';
  String vnpIpAddr = ipAddress;
  String vnpTmnCode = Contant.vnpTmnCode;
  String? vnpOrderType = Contant.mapOrderType[orderType];
  String? vnpBankCode = Contant.mapBank[bankCode];
  String? vnpLocate = Contant.mapLanguage[locate];

  var vnpParams = {};
  vnpParams['vnp_Version'] = vnpVersion;
  vnpParams['vnp_Command'] = vnpCommand;
  vnpParams['vnp_TmnCode'] = vnpTmnCode;
  vnpParams['vnp_Amount'] = '${amount}00';
  vnpParams['vnp_CurrCode'] = 'VND';
  if (vnpBankCode != null) {
    vnpParams['vnp_BankCode'] = vnpBankCode;
  }
  vnpParams['vnp_TxnRef'] = vnpTxnRef;
  vnpParams['vnp_OrderInfo'] = orderInfo;
  vnpParams['vnp_OrderType'] = vnpOrderType;
  vnpParams['vnp_Locale'] = vnpLocate;
  vnpParams['vnp_ReturnUrl'] = Contant.vnpReturnurl;
  vnpParams['vnp_IpAddr'] = vnpIpAddr;

  // Lấy thời gian hiện tại
  var now = DateTime.now();
  var formatterDate = DateFormat('yyyyMMddHHmmss');
  vnpParams['vnp_CreateDate'] = formatterDate.format(now);
  // ExpireDate
  var expireDate = now.add(const Duration(minutes: 5));
  vnpParams['vnp_ExpireDate'] = formatterDate.format(expireDate);

  List fieldNames = vnpParams.keys.toList();
  fieldNames = (fieldNames..sort());
  // print(fieldNames);
  final hashData = StringBuffer();
  final query = StringBuffer();

  for (var item in fieldNames) {
    String fieldName = item;
    String fieldValue = vnpParams[fieldName];
    if ((fieldValue != null) && (fieldValue.isNotEmpty)) {
      hashData.write(fieldName);
      hashData.write('=');
      hashData.write(Uri.encodeQueryComponent(fieldValue));
      if (fieldNames.last != item) {
        hashData.write('&');
      }

      query.write(Uri.encodeQueryComponent(fieldName));
      query.write('=');
      query.write(Uri.encodeQueryComponent(fieldValue));
      if (fieldNames.last != item) {
        query.write('&');
      }
    }
  }
  var key = utf8.encode(Contant.vnpHashSecret);
  var bytes = utf8.encode(hashData.toString());
  var hmacSha512 = Hmac(sha512, key);
  Digest vnpSecureHash = hmacSha512.convert(bytes);

  String queryUrl = '$query&vnp_SecureHash=$vnpSecureHash';
  String paymentUrl = '${Contant.vnpPayUrl}?$queryUrl';

  return paymentUrl;
}
