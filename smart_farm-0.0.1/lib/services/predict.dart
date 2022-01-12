import 'dart:convert';

import 'package:http/http.dart';

class Predict {
  Future<String> predict(String temp, String rainfall, double ph, String soil,
      String month) async {
    final Map<String, dynamic> data = {
      'rain': double.parse(rainfall),
      'temp': double.parse(temp),
      'ph': ph,
      'month': month,
      'soil': soil,
    };

    Response res = await post(
      Uri.parse('https://cryptic-wildwood-62360.herokuapp.com/predict'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print(res.body);

    final Map<String, dynamic> responseData = jsonDecode(res.body);

    return responseData['prediction'];
  }
}
