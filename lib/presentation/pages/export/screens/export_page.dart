import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ExtractColorsPage extends StatefulWidget {
  const ExtractColorsPage({super.key});

  @override
  State<ExtractColorsPage> createState() => _ExtractColorsPageState();
}

class _ExtractColorsPageState extends State<ExtractColorsPage> {
  File? imageFile;
  List<Color> extractedColors = [];

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });

      extractColors(picked.path);
    }
  }

  Future extractColors(String path) async {
    final bytes = await File(path).readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse("http://YOUR_API_URL/colors"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"image": base64Image}),
    );

    if (response.statusCode == 200) {
      final List colors = jsonDecode(response.body)["colors"];

      setState(() {
        extractedColors = colors
            .map((hex) => Color(int.parse("0xFF${hex.substring(1)}")))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🔥 خلفية متداخلة Gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF8360c3),
              Color(0xFF2ebf91),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                children: [
                  // =============================
                  //      TITLES
                  // =============================

                  const Text(
                    "Choose color from any image",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Upload your photo to extract colors from HEX, RGB and more",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // =============================
                  //      UPLOAD BUTTON
                  // =============================
                  Center(
                    child: GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFff9966),
                              Color(0xFFff5e62),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Text(
                          "Upload Photo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =============================
                  //      IMAGE CONTAINER
                  // =============================

                  if (imageFile != null)
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white, width: 2),
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              imageFile!,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // زرار X لحذف الصورة
                        Positioned(
                          right: 10,
                          top: 10,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                imageFile = null;
                                extractedColors.clear();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 30),

                  // =============================
                  //      EXTRACTED COLORS
                  // =============================

                  if (extractedColors.isNotEmpty)
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: extractedColors
                          .map(
                            (c) => Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: c,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
