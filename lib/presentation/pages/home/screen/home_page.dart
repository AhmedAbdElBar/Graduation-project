import 'package:flutter/material.dart';
import 'package:login_page/presentation/core/resources/padding_margin_value_manager.dart';
import 'package:login_page/presentation/pages/home/widget/custom_container_for_home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: PaddingValueManager.eAll15,
        child: ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) {
            return CustomContainerForHomePage(index: index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 10);
          },
        ),
      ),
    );
  }
}
