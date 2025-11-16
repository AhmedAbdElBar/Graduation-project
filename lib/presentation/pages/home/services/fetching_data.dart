import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



/// 🔹 جلب Palette من API colormind
Future<List<List<Color>>> fetchPalettesFromApi(int count) async {
  List<List<Color>> fetchedPalettes = [];

  for (int i = 0; i < count; i++) {
    try {
      final response = await http.post(
        Uri.parse('http://colormind.io/api/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'model': 'default'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List result = data['result'];
        fetchedPalettes.add(
          result
              .map((rgb) => Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1))
              .toList()
              .cast<Color>(),
        );
      }
    } catch (e) {
      debugPrint('Error fetching palette: $e');
    }
  }

  return fetchedPalettes;
}
