import 'dart:math';

import 'package:flutter/widgets.dart';

import '../data/kite_service.dart';
import '../data/models/content.dart';
import '../theme/components/dialog.dart';
import '../theme/kite_theme.dart';
import '../utils/screen_utils.dart';
import '../view_model/actions/intents.dart';
import '../view_model/categories_search_view_model.dart';
import '../view_model/kite_view_model.dart';
import '../view_model/provider/kite_provider.dart';
import 'categories_search_view.dart';
import 'content_view.dart';
import 'keybindings_help.dart';
import 'sidebar/sidebar_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = KiteTheme.of(context);
    return ColoredBox(
      color: theme.background,
      child: ValueListenableBuilder(
        valueListenable: KiteProvider.of<KiteViewModel>(context).popupType,
        builder: (context, popupType, _) => Stack(
          alignment: Alignment.center,
          children: [
            LayoutBuilder(
              builder: (context, constraints) => switch (constraints.maxWidth > screenSizeBreakpoint) {
                /// single page view for smaller screens
                false => ValueListenableBuilder(
                  valueListenable: KiteProvider.of<KiteViewModel>(context).currentCategoryContent,
                  builder: (context, clusters, _) {
                    return switch (clusters) {
                      (final Content selectedContent, _) => ContentView(selectedContent),
                      _ => const SidebarView(),
                    };
                  },
                ),

                /// split view for larger screens
                true => Row(
                  spacing: 16,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: min(500, MediaQuery.sizeOf(context).width / 5 * 2)),
                      child: const SidebarView(),
                    ),
                    Expanded(
                      child: Center(
                        child: ValueListenableBuilder(
                          valueListenable: KiteProvider.of<KiteViewModel>(context).currentCategoryContent,
                          builder: (context, value, _) => ContentView(value.$1),
                        ),
                      ),
                    ),
                  ],
                ),
              },
            ),

            if (popupType != PopupType.none) const ColoredBox(color: Color(0x80000000), child: SizedBox.expand()),
            switch (popupType) {
              PopupType.none => const SizedBox.shrink(),
              PopupType.categoriesList => Positioned(
                width: min(MediaQuery.sizeOf(context).shortestSide, screenSizeBreakpoint),
                bottom: switch (MediaQuery.viewInsetsOf(context).bottom) {
                  final softKeyboardHeight when softKeyboardHeight > 0 => softKeyboardHeight,
                  _ => null,
                },
                height: MediaQuery.sizeOf(context).height / 2,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Dialog(
                      onClose: Actions.handler(context, const ToggleCategoriesListIntent()),
                      child: CategoriesSearchView(CategoriesSearchViewModel(KiteProvider.of<KiteService>(context))),
                    ),
                  ),
                ),
              ),
              PopupType.help => Dialog(
                onClose: () => Actions.invoke(context, const ToggleKeybindingsHelpIntent()),
                child: const KeybindingsHelpView(),
              ),
            },
          ],
        ),
      ),
    );
  }
}
