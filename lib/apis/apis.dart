import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:paginatedapi/model/home_model.dart';

class APIFunction {
  Future<HomeModel> getProducts({required int page}) async {
    const String token =
        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7InVpZCI6InhNcEhNUm9GTWNON3NCOXUwVnE3aXZPQm1lczEiLCJyb2xlIjoic3Vic2NyaWJlciJ9LCJpYXQiOjE3NTAyMzQ4NjEsImV4cCI6MTc1MDMyMTI2MX0.iDDkEtp3g8heXIs4OjD6obaV0qYCvEzLrQ2uxLCxmi0";
    const String baseUrl = "https://buyer-app.prod.shopcircuit.ai/product/filter/v1";

    final headers = {
      'Content-Type': 'application/json',
      'x-server-token': "8ff57b7c-faf3-49b0-9bf3-aeb12515424d",
      'Authorization': token,
    };

    final queryParams = {
      "f":
          "ondc_category_id:Casual shoes, Heels, Boots, Ethnic Shoes, Work & Safety Shoes, Outdoor Shoes, Sports Shoes, Formal Shoes, Sandals Floaters, Flip-Flops & Flats",
      "s": "",
      "option": "dashboard",
      "p": page.toString(),
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return HomeModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load products');
    }
  }
}
