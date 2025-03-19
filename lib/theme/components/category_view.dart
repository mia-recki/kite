import 'package:flutter/widgets.dart';

import '../../theme/kite_theme.dart';

class CategoryView extends StatelessWidget {
  const CategoryView(this.category, {super.key});

  final String category;

  @override
  Widget build(BuildContext context) => Text(
    category,
    style: TextStyle(color: category.color(KiteTheme.of(context).categoryColors)),
    semanticsLabel: 'Subcategory: $category',
  );
}

extension on String {
  // from kite-public/kite.css
  Color color(List<Color> availableColors) =>
      availableColors[(codeUnitAt(0) + codeUnitAt(1) + length) % availableColors.length];
}
