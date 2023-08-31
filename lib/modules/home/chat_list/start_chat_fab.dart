import 'package:firebasedemo/config/app_themes.dart';
import 'package:flutter/material.dart';
import 'chat_list.dart';

class StartChatFloatingActionButton extends StatelessWidget {
  final ActiveFilter activeFilter;
  final ValueNotifier<bool> scrolledToTop;
  final bool roomsIsEmpty;

  const StartChatFloatingActionButton({
    Key? key,
    required this.activeFilter,
    required this.scrolledToTop,
    required this.roomsIsEmpty,
  }) : super(key: key);

  void _onPressed(BuildContext context) {
    switch (activeFilter) {
      case ActiveFilter.messages:
        //VRouter.of(context).to('/newprivatechat');
        break;
      case ActiveFilter.groups:
        //VRouter.of(context).to('/newgroup');
        break;
    }
  }

  IconData get icon {
    switch (activeFilter) {
      case ActiveFilter.messages:
        return Icons.add_outlined;
      case ActiveFilter.groups:
        return Icons.group_add_outlined;
    }
  }

  String getLabel(BuildContext context) {
    switch (activeFilter) {
      case ActiveFilter.messages:
        return 'newChat';
      case ActiveFilter.groups:
        return 'newGroup';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: scrolledToTop,
      builder: (context, scrolledToTop, _) => AnimatedSize(
        duration: AppThemes.animationDuration,
        curve: AppThemes.animationCurve,
        clipBehavior: Clip.none,
        child: scrolledToTop
            ? FloatingActionButton.extended(
                onPressed: () => _onPressed(context),
                icon: Icon(icon),
                label: Text(
                  getLabel(context),
                  overflow: TextOverflow.fade,
                ),
              )
            : FloatingActionButton(
                onPressed: () => _onPressed(context),
                child: Icon(icon),
              ),
      ),
    );
  }
}
