import 'package:flutter/widgets.dart';

import 'header_text.dart';

class SectionView extends StatelessWidget {
  const SectionView(this.title, {required this.child, super.key});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [HeaderText(title), child],
    );
  }
}
