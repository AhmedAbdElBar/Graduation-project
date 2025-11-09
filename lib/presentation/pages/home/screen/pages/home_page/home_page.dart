import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_page/presentation/core/resources/color_value_manager.dart';
import 'package:login_page/presentation/pages/authPage/screens/auth_screen.dart';
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

  List<int> items = List.generate(10, (index) => index);
  bool isLoadingMore = false;
  int refreshId = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Pagination scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isLoadingMore) {
        _loadMore();
      }
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      items = List.generate(10, (index) => index);
      refreshId++;
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
            const Icon(Icons.apple_outlined),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
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
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Yes'),
                        ),
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
          child: GridView.builder(
            key: ValueKey(refreshId),
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: items.length + 1, // +1 للـ loading indicator
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              if (index < items.length) {
                return CustomContainerForHomePage(index: items[index]);
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
