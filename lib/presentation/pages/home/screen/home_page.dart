import 'package:flutter/material.dart';
import 'package:login_page/presentation/core/resources/padding_margin_value_manager.dart';
import 'package:login_page/presentation/pages/home/widget/custom_container_for_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  int refreshId = 0; // ✅ المفتاح لإعادة بناء الـ ListView بالكامل
  List<int> items = List.generate(10, (index) => index); // أول 10 عناصر
  bool isLoadingMore = false;

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      refreshId++; // ✅ نغير المفتاح لإعادة بناء ListView بالكامل
      items = List.generate(10, (index) => index); // إعادة تحميل أول 10 عناصر
    });
  }

  Future<void> _loadMore() async {
    setState(() => isLoadingMore = true);

    await Future.delayed(const Duration(seconds: 1));

    final nextItems = List.generate(10, (index) => items.length + index);

    setState(() {
      items.addAll(nextItems);
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Padding(
        padding: PaddingValueManager.eAll15,
        child: RefreshIndicator(
          key: _refreshKey,
          onRefresh: _refresh,
          child: ListView.separated(
            key: ValueKey(refreshId), // ✅ إعادة بناء كاملة عند كل refresh
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: items.length + 1, // +1 للزر Show More
            itemBuilder: (context, index) {
              if (index == items.length) {
                // زر Show More
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: isLoadingMore
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _loadMore,
                            child: const Text("Show More"),
                          ),
                  ),
                );
              }
              // باقي العناصر العادية
              return CustomContainerForHomePage(index: items[index]);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          ),
        ),
      ),
    );
  }
}
