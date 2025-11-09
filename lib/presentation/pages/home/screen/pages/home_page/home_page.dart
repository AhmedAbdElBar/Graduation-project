import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_page/presentation/core/resources/color_value_manager.dart';
import 'package:login_page/presentation/core/resources/padding_margin_value_manager.dart';
import 'package:login_page/presentation/pages/auth/screens/auth_screen.dart';
import 'package:login_page/presentation/pages/home/widget/custom_container_for_home_page.dart';

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
  List<List<Color>> filteredPalettes = [];

  bool isLoading = true;
  bool isLoadingMore = false;
  bool isSearching = false;
  int refreshId = 0;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchInitialPalettes();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isLoadingMore &&
          !isSearching) {
        _loadMore();
      }
    });

    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 600), _filterResults);
    });
  }

  /// 🔹 جلب أول مجموعة من الـ palettes
  Future<void> fetchInitialPalettes() async {
    setState(() => isLoading = true);
    final palettes = await fetchPalettesFromApi(10);
    setState(() {
      allPalettes = palettes;
      filteredPalettes = List.from(allPalettes);
      isLoading = false;
    });
  }

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

  Future<void> _filterResults() async {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      filteredPalettes = [];
    });

    int desiredCount = 10; // عدد النتائج المطلوب عرضها
    int attempts = 0; // لمنع اللانهاية
    int maxAttempts = 50;

    List<List<Color>> matches = [];

    while (matches.length < desiredCount && attempts < maxAttempts) {
      attempts++;

      // جلب دفعة جديدة من palettes (مثلاً 5 لكل مرة)
      final fetchedPalettes = await fetchPalettesFromApi(5);

      // تصفية النتائج
      List<List<Color>> newMatches = fetchedPalettes.where((palette) {
        return palette.any((color) {
          String name = _approxColorName(color);
          return name.contains(query);
        });
      }).toList();

      matches.addAll(newMatches);
    }

    setState(() {
      filteredPalettes = matches.take(desiredCount).toList();
      isLoading = false;
    });
  }

  /// 🧠 تحويل اللون إلى اسم تقريبي (يغطي معظم الألوان الشائعة)
  String _approxColorName(Color color) {
    int r = color.red;
    int g = color.green;
    int b = color.blue;

    // 🔴 الأحمر
    if (r > 180 && g < 80 && b < 80) return 'red';

    // 🟠 البرتقالي
    if (r > 200 && g > 100 && g < 180 && b < 80) return 'orange';

    // 🟡 الأصفر
    if (r > 200 && g > 200 && b < 100) return 'yellow';

    // 🟢 الأخضر
    if (g > 150 && r < 120 && b < 120) return 'green';

    // 🟢 فاتح (ليموني)
    if (r > 170 && g > 220 && b < 120) return 'lime';

    // 🔵 الأزرق
    if (b > 160 && r < 100 && g < 140) return 'blue';

    // 🩵 السماوي (أزرق فاتح)
    if (b > 180 && g > 180 && r < 120) return 'cyan';

    // 🟣 البنفسجي
    if (r > 150 && b > 150 && g < 100) return 'purple';

    // 💜 الموف
    if (r > 180 && b > 180 && g < 150) return 'violet';

    // 💗 الوردي
    if (r > 220 && g < 180 && b > 200) return 'pink';

    // 🟤 البني
    if (r > 100 && g > 60 && b < 40) return 'brown';

    // ⚫ الأسود
    if (r < 50 && g < 50 && b < 50) return 'black';

    // ⚪ الأبيض
    if (r > 230 && g > 230 && b > 230) return 'white';

    // ⚙️ الرمادي
    if ((r - g).abs() < 20 && (g - b).abs() < 20) {
      if (r > 180) return 'light gray';
      if (r > 100) return 'gray';
      return 'dark gray';
    }

    // 🎨 fallback
    return 'other';
  }

  /// 🔹 سحب لتحديث
  Future<void> _refresh() async {
    await fetchInitialPalettes();
    refreshId++;
  }

  /// 🔹 تحميل المزيد (Pagination)
  Future<void> _loadMore() async {
    setState(() => isLoadingMore = true);
    final newPalettes = await fetchPalettesFromApi(10); // ✅ بدل 5 → 10

    setState(() {
      allPalettes.addAll(newPalettes);
      filteredPalettes = List.from(allPalettes);
      isLoadingMore = false;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
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
            const Icon(Icons.palette_outlined),
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
                  builder: (context) {
                    return AlertDialog(
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
                    );
                  },
                );
                if (confirm == true) {
                  await _logout();
                }
              },
              icon: const Icon(Icons.logout),
              tooltip: 'Log out',
            ),
          ],
        ),
      ),
      body: Padding(
        padding: PaddingValueManager.eAll15,
        child: RefreshIndicator(
          key: _refreshKey,
          onRefresh: _refresh,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  key: ValueKey(refreshId),
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filteredPalettes.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    if (index < filteredPalettes.length) {
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
    );
  }
}
