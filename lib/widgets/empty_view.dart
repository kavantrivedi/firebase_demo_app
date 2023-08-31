import 'dart:math';

import 'package:firebasedemo/resources/assets_manager.dart';
import 'package:firebasedemo/resources/tag_manager.dart';
import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final bool loading;
  static const double _width = 300;
  const EmptyView({this.loading = false, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery.of(context).size.width, EmptyView._width) / 2;
    return Scaffold(
      // Add invisible appbar to make status bar on Android tablets bright.
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Hero(
              tag: TagManager.infoLogo,
              child: Image.asset(
                AssetsManager.favicon,
                width: width,
                height: width,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ),
          if (loading)
            Center(
              child: SizedBox(
                width: width,
                child: const LinearProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
