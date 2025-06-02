import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/kite_theme.dart';
import '../../view_model/actions/intents.dart';
import '../../view_model/actions/shortcut_mapping.dart';
import '../../view_model/categories_search_view_model.dart';

class CategoriesSearchView extends StatefulWidget {
  const CategoriesSearchView(this.viewModel, {super.key});
  final CategoriesSearchViewModel viewModel;

  @override
  State<CategoriesSearchView> createState() => _CategoriesSearchViewState();
}

class _CategoriesSearchViewState extends State<CategoriesSearchView> {
  final _focusNode = FocusNode(debugLabel: 'CategoriesSearchView')..requestFocus();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.viewModel.search(_controller.text);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = KiteTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
          valueListenable: widget.viewModel.searchResults,
          builder: (context, searchResult, _) {
            return Flexible(
              child: ListView(
                reverse: true,
                children: [
                  ...(searchResult.$2
                      .mapIndexed<Widget>(
                        (i, category) => GestureDetector(
                          onTap: Actions.handler(context, SelectCategoryIntent(category)),
                          child: Text(
                            category.name,
                            style: i == searchResult.$1
                                ? theme.searchBoxTextStyle.copyWith(
                                    decoration: TextDecoration.underline,
                                    decorationColor: theme.kagiYellow,
                                    backgroundColor: theme.focusedItemBackground,
                                  )
                                : theme.searchBoxTextStyle,
                          ),
                        ),
                      )
                      .toList()),
                ],
              ),
            );
          },
        ),
        Shortcuts(
          shortcuts:
              Map.fromEntries(
                // ignore app-level shortcuts inside of the text field
                appLevelShortcuts.keys.map(
                  (activator) => MapEntry(activator, const DoNothingAndStopPropagationTextIntent()),
                ),
              )..addAll({
                const SingleActivator(LogicalKeyboardKey.arrowUp): VoidCallbackIntent(widget.viewModel.focusNextResult),
                const SingleActivator(LogicalKeyboardKey.arrowDown): VoidCallbackIntent(
                  widget.viewModel.focusPreviousResult,
                ),
                const SingleActivator(LogicalKeyboardKey.escape): const ToggleCategoriesListIntent(),
              }),
          child: FocusScope(
            child: EditableText(
              controller: _controller,
              focusNode: _focusNode,
              style: theme.searchBoxTextStyle,
              cursorColor: theme.kagiYellow,
              backgroundCursorColor: theme.kagiYellow,
              onSubmitted: (_) => Actions.invoke(
                context,
                SelectCategoryIntent(widget.viewModel.searchResults.value.focusedCategory),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
