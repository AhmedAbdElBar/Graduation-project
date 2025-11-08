import 'package:flutter/material.dart';
import 'package:login_page/presentation/core/resources/padding_margin_value_manager.dart';
import 'package:login_page/presentation/pages/home/widget/custom_container_for_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ✅ هنضيف مفتاح للتحكم في الـ RefreshIndicator
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  // علشان نعمل "إعادة بناء كاملة" للـ ListView لما نعمل refresh
  int refreshId = 0;

  Future<void> _refresh() async {
    // نعمل delay بسيط كأنه تحميل من الإنترنت
    await Future.delayed(const Duration(seconds: 1));

    // ✅ نغير الـ refreshId عشان نعمل rebuild كامل للـ list
    setState(() {
      refreshId++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: PaddingValueManager.eAll15,
        child: RefreshIndicator(
          key: _refreshKey,
          onRefresh: _refresh,
          child: ListView.separated(
            key: ValueKey(refreshId), // ✅ مفتاح مختلف لكل refresh
            itemCount: 10,
            itemBuilder: (context, index) {
              return CustomContainerForHomePage(index: index);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 10);
            },
          ),
        ),
      ),
    );
  }
}
