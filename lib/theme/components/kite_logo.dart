import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../kite_theme.dart';

class KiteLogo extends StatelessWidget {
  const KiteLogo({this.width, this.height, super.key});
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      switch (KiteTheme.of(context).brightness) {
        ThemeBrightness.dark => 'assets/img/kite-dark.svg',
        ThemeBrightness.light => 'assets/img/kite.svg',
      },
      fit: BoxFit.fitHeight,
      width: width,
      height: height,
    );
  }
}
