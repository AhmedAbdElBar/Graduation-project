import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:login_page/presentation/core/resources/ip_address.dart';
import 'package:login_page/presentation/pages/home/widget/custom_container_for_home_page.dart'; // ← مهم للـ Clipboard

class ExtractColorsPage extends StatefulWidget {
  const ExtractColorsPage({super.key});

  @override
  State<ExtractColorsPage> createState() => _ExtractColorsPageState();
}

class _ExtractColorsPageState extends State<ExtractColorsPage> {
  File? imageFile;
  List<Color> extractedColors = [];
  List<Color> paletteColors = [];
  List<Color> selectedColors = [];
  bool isLoading = false;

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
        extractedColors.clear();
      });

      extractColors(picked.path);
    }
  }

  // Upload image to server and extract colors
  //===============================
  // IP address of local server
  //===============================
  String? ip = IpAddress.ipAddress;

  Future extractColors(String path) async {
    final String apiUrl = "http://$ip:5000/image/extract-colors";
    setState(() {
      isLoading = true;
    });

    try {
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          path,
        ),
      );

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List colors = data["colors"] ?? [];
        setState(() {
          extractedColors = colors
              .map((colorObj) =>
                  Color(int.parse("0xFF${colorObj["hex"].substring(1)}")))
              .toList();
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Server error: ${response.statusCode} ${response.reasonPhrase}"),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
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
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: SafeArea(
              child: Column(
                children: [
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

                  // UPLOAD BUTTON
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

                  // IMAGE CONTAINER
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
                        Positioned(
                          right: 10,
                          top: 10,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                imageFile = null;
                                extractedColors.clear();
                                paletteColors.clear();
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

                  // PROGRESS INDICATOR
                  if (isLoading)
                    const CircularProgressIndicator(
                      color: Colors.white,
                    ),

                  const SizedBox(height: 20),

                  // EXTRACTED COLORS
                  if (extractedColors.isNotEmpty)
                    Column(
                      children: [
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: extractedColors.map((color) {
                            String hexCode =
                                '#${color.value.toRadixString(16).substring(2).toUpperCase()}';

                            Color textColor = (0.299 * color.red +
                                        0.587 * color.green +
                                        0.114 * color.blue) >
                                    186
                                ? Colors.black
                                : Colors.white;
                            bool isSelected = selectedColors.contains(color);
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedColors.remove(color);
                                    } else {
                                      if (selectedColors.length < 5) {
                                        selectedColors.add(color);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "You can select only 5 colors"),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  width:
                                      (MediaQuery.of(context).size.width - 60) /
                                          2,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: color, // ← مهم جدًا
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          hexCode,
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(
                                              ClipboardData(text: hexCode));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Copied $hexCode to clipboard"),
                                              duration:
                                                  const Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.copy,
                                          color: textColor,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          }).toList(),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            if (selectedColors.length != 5) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Please select exactly 5 colors"),
                                ),
                              );
                              return;
                            }

                            setState(() {
                              paletteColors = List.from(selectedColors);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF00c6ff),
                                  Color(0xFF0072ff),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: const Text(
                              "Create Palette",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (paletteColors.isNotEmpty)
                          CustomContainerForHomePage(
                            index: 0,
                            colors: paletteColors,
                          ),
                      ],
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
