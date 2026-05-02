import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_page/presentation/core/resources/ip_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_page/presentation/core/resources/color_value_manager.dart';
import 'package:login_page/presentation/pages/auth/services/log_out.dart';
import 'package:login_page/presentation/pages/home/services/fetching_data.dart';
import 'package:login_page/presentation/pages/home/widget/custom_container_for_home_page.dart';
import '../../../widget/skeleton_widget.dart';

// تحويل Hex → Color
Color hexToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

// API search
Future<List<List<Color>>> fetchPalettesByColor(String color) async {
  String? ip = IpAddress.ipAddress;
  final response = await http.post(
    Uri.parse("http://$ip:5000/palettes/by-color"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'color': color}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    List<dynamic> palettesJson = data['palettes'];

    return palettesJson.map<List<Color>>((palette) {
      List<dynamic> colorsList = palette['colors'];
      return colorsList
          .map<Color>((hex) => hexToColor(hex.toString()))
          .toList();
    }).toList();
  } else {
    throw Exception("Failed to fetch palettes");
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<List<Color>> allPalettes = [];
  static List<List<Color>> myPalettes = [];
  List<List<Color>> filteredPalettes = [];

  bool isLoading = true;
  bool isLoadingMore = false;
  bool isSearching = false;
  int refreshId = 0;

  @override
  void initState() {
    super.initState();
    _loadPalettesFromCacheOrApi();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isLoadingMore &&
          _searchController.text.isEmpty) {
        _loadMore();
      }
    });
  }

  /// SEARCH
  Future<void> _filterResults() async {
    String query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        filteredPalettes = List.from(myPalettes);
        isSearching = false;
      });
      return;
    }

    setState(() => isSearching = true);

    try {
      final palettes = await fetchPalettesByColor(query);

      setState(() {
        filteredPalettes = palettes;
      });
    } catch (e) {
      debugPrint("Search Error: $e");
    } finally {
      setState(() => isSearching = false);
    }
  }

  /// Refresh
  Future<void> _refresh() async {
    setState(() => isLoading = true);

    final palettes = await fetchPalettesFromApi(10);

    myPalettes = palettes;
    filteredPalettes = List.from(myPalettes);

    await _savePalettesToCache();

    setState(() {
      isLoading = false;
      refreshId++;
    });
  }

  /// Load cache
  Future<void> _loadPalettesFromCacheOrApi() async {
    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('my_palettes');

    if (cached != null) {
      List<dynamic> decoded = jsonDecode(cached);
      myPalettes = decoded.map<List<Color>>((palette) {
        return (palette as List)
            .map<Color>((colorValue) => Color(colorValue))
            .toList();
      }).toList();

      filteredPalettes = List.from(myPalettes);
      setState(() => isLoading = false);
    } else {
      await _fetchInitialPalettes();
    }
  }

  /// First fetch
  Future<void> _fetchInitialPalettes() async {
    final palettes = await fetchPalettesFromApi(10);
    myPalettes = palettes;
    filteredPalettes = List.from(myPalettes);
    await _savePalettesToCache();
    setState(() => isLoading = false);
  }

  /// Save cache
  Future<void> _savePalettesToCache() async {
    final prefs = await SharedPreferences.getInstance();
    List<List<int>> toSave = myPalettes
        .map((palette) => palette.map((c) => c.value).toList())
        .toList();
    await prefs.setString('my_palettes', jsonEncode(toSave));
  }

  /// Load more
  Future<void> _loadMore() async {
    setState(() => isLoadingMore = true);

    final newPalettes = await fetchPalettesFromApi(10);

    allPalettes.addAll(newPalettes);
    filteredPalettes.addAll(newPalettes);

    await _savePalettesToCache();

    setState(() => isLoadingMore = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorValueManager.vWhiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.palette_outlined, color: Colors.grey.shade800),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search (e.g. #FF0000 or 255,0,0)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  suffixIcon: isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : const Icon(Icons.search),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) async {
                  await _filterResults();
                },
              ),
            ),
            IconButton(
              onPressed: () async {
                bool? confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No')),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Yes')),
                    ],
                  ),
                );
                if (confirm == true) await logout(context);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: RefreshIndicator(
              key: _refreshKey,
              onRefresh: _refresh,
              child: GridView.builder(
                key: ValueKey(refreshId),
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: isLoading ? 6 : filteredPalettes.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  if (isLoading) {
                    return const PaletteSkeleton();
                  } else if (index < filteredPalettes.length) {
                    return CustomContainerForHomePage(
                      index: index,
                      colors: filteredPalettes[index].take(5).toList(),
                    );
                  } else {
                    // Show Load More button if searching, else loader for scroll
                    if (_searchController.text.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: isLoadingMore
                                ? null
                                : () async {
                                    setState(() => isLoadingMore = true);
                                    try {
                                      final newPalettes =
                                          await fetchPalettesByColor(
                                              _searchController.text);
                                      setState(() {
                                        filteredPalettes.addAll(newPalettes);
                                      });
                                    } catch (e) {
                                      debugPrint("Load more search error: $e");
                                    } finally {
                                      setState(() => isLoadingMore = false);
                                    }
                                  },
                            child: isLoadingMore
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Load More'),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: isLoadingMore
                              ? const CircularProgressIndicator()
                              : const SizedBox.shrink(),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ),

          // 🔥 loading bar فوق أثناء البحث
          if (isSearching)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(minHeight: 3),
            ),
        ],
      ),
    );
  }
}
