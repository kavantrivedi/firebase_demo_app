import 'package:firebasedemo/resources/assets_manager.dart';
import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../config/app_themes.dart';

class AuthLayout extends StatelessWidget {
  final Widget body;
  final AppBar? appBar;

  const AuthLayout({
    Key? key,
    required this.body,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobileMode = !AppThemes.isColumnMode(context);
    if (isMobileMode) return _buildScaffold(isMobileMode);
    return Container(
      decoration: BoxDecoration(
        gradient: AppThemes.backgroundGradient(context, 156),
      ),
      child: Column(
        children: [
          const SizedBox(height: 64),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                  clipBehavior: Clip.hardEdge,
                  elevation:
                      Theme.of(context).appBarTheme.scrolledUnderElevation ?? 4,
                  shadowColor: Theme.of(context).appBarTheme.shadowColor,
                  child: ConstrainedBox(
                    constraints: isMobileMode
                        ? const BoxConstraints()
                        : const BoxConstraints(maxWidth: 960, maxHeight: 640),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.asset(
                            AssetsManager.authBanner,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          width: 1,
                          color: Theme.of(context).dividerTheme.color,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildScaffold(isMobileMode),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScaffold(bool isMobileMode) {
    return Scaffold(
      key: const Key('LoginScaffold'),
      backgroundColor: isMobileMode ? null : Colors.transparent,
      appBar: appBar == null
          ? null
          : AppBar(
              titleSpacing: appBar?.titleSpacing,
              automaticallyImplyLeading:
                  appBar?.automaticallyImplyLeading ?? true,
              centerTitle: appBar?.centerTitle,
              title: appBar?.title,
              leading: appBar?.leading,
              actions: appBar?.actions,
              backgroundColor: isMobileMode ? null : Colors.transparent,
            ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: body,
    );
  }
}
