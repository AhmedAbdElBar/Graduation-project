import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login_page/presentation/pages/home/services/search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_page/presentation/core/resources/color_value_manager.dart';
import 'package:login_page/presentation/pages/auth/services/log_out.dart';
import 'package:login_page/presentation/pages/home/services/fetching_data.dart';
import 'package:login_page/presentation/pages/home/widget/custom_container_for_home_page.dart';

import '../../../widget/skeleton_widget.dart';

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
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadPalettesFromCacheOrApi();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isLoadingMore) {
        _loadMore();
      }
    });

    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 600), _filterResults);
    });
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });

    final palettes = await fetchPalettesFromApi(10);

    myPalettes = palettes;
    filteredPalettes = List.from(myPalettes);

    await _savePalettesToCache();

    setState(() {
      isLoading = false;
      refreshId++;
    });
  }

  ///  Load from SharedPreferences or API
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

  ///  Fetch from API
  Future<void> _fetchInitialPalettes() async {
    final palettes = await fetchPalettesFromApi(10);
    myPalettes = palettes;
    filteredPalettes = List.from(myPalettes);
    await _savePalettesToCache();
    setState(() => isLoading = false);
  }

  ///  Save to SharedPreferences
  Future<void> _savePalettesToCache() async {
    final prefs = await SharedPreferences.getInstance();
    List<List<int>> toSave = myPalettes
        .map((palette) => palette.map((c) => c.value).toList())
        .toList();
    await prefs.setString('my_palettes', jsonEncode(toSave));
  }

  ///  Filter results
  Future<void> _filterResults() async {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredPalettes = List.from(myPalettes);
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    int desiredCount = 10;
    int attempts = 0;
    int maxAttempts = 50;
    List<List<Color>> matches = [];

    while (matches.length < desiredCount && attempts < maxAttempts) {
      attempts++;

      final fetchedPalettes = await fetchPalettesFromApi(5);

      List<List<Color>> newMatches = fetchedPalettes.where((palette) {
        return palette.any((color) {
          String name = approxColorName(color);
          return name.contains(query);
        });
      }).toList();

      matches.addAll(newMatches);
    }

    filteredPalettes = matches.take(desiredCount).toList();

    myPalettes.addAll(filteredPalettes);
    await _savePalettesToCache();

    setState(() {
      isSearching = false;
    });
  }

  ///  Load more palettes
  Future<void> _loadMore() async {
    setState(() => isLoadingMore = true);

    final newPalettes = await fetchPalettesFromApi(10);

    allPalettes.addAll(newPalettes);

    if (_searchController.text.isNotEmpty) {
      String query = _searchController.text.toLowerCase();
      filteredPalettes = allPalettes.where((palette) {
        return palette.any((color) {
          String name = approxColorName(color);
          return name.contains(query);
        });
      }).toList();
    } else {
      filteredPalettes = List.from(allPalettes);
    }

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
                  hintText: 'Search color (e.g. red, blue)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  suffixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                ),
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
              tooltip: 'Log out',
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
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: isLoadingMore
                            ? const CircularProgressIndicator()
                            : const SizedBox.shrink(),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          if (isSearching)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                minHeight: 4,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
        ],
      ),
    );
  }
}
