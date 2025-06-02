import 'package:flutter/widgets.dart';

import '../kite_theme.dart';

class HeaderText extends StatelessWidget {
  const HeaderText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: KiteTheme.of(context).headerTextStyle);
  }
}
