import 'package:flutter/widgets.dart';

enum ThemeBrightness { dark, light }

class ThemeData {
  final ThemeBrightness brightness;

  ThemeData(this.brightness);

  Color get background => switch (brightness) {
    ThemeBrightness.dark => const Color(0xFF1A202C),
    ThemeBrightness.light => const Color(0xFFFFFFFF),
  };

  Color get textColor => switch (brightness) {
    ThemeBrightness.dark => const Color(0xFFFFFFFF),
    ThemeBrightness.light => const Color(0xFF1E2939),
  };

  final kagiYellow = const Color(0xFFF3B644);

  Color get inlineUrlColor => switch (brightness) {
    ThemeBrightness.dark => const Color(0xFF5B89FF),
    ThemeBrightness.light => const Color(0xFF183FDC),
  };

  Color get didYouKnowBg => switch (brightness) {
    ThemeBrightness.dark => const Color(0xFF2A3B5E),
    ThemeBrightness.light => const Color(0xFFCED8FB),
  };

  Color get actionItemsBg => switch (brightness) {
    ThemeBrightness.dark => const Color(0xFF2B411C),
    ThemeBrightness.light => const Color(0xFFF1FAE8),
  };

  Color get textBoxBg => switch (brightness) {
    ThemeBrightness.dark => const Color(0xFF364153),
    ThemeBrightness.light => const Color(0xFFF3F4F6),
  };

  final talkingPointCircleBg = const Color(0xFFF9D9B8);
  final talkingPointCircleText = const Color(0xFF1E2939);

  Color get talkingPointsDivider => switch (brightness) {
    ThemeBrightness.dark => const Color(0xFFD1D5DC),
    ThemeBrightness.light => const Color(0xFF4A5565),
  };

  final categoryColors = const [
    Color(0xFFCC3333),
    Color(0xFFB85C2E),
    Color(0xFF0077CC),
    Color(0xFF666633),
    Color(0xFF8822CC),
    Color(0xFFB8288F),
    Color(0xFFE60039),
    Color(0xFF00855A),
    Color(0xFFD14900),
  ];

  TextStyle get defaultTextStyle => TextStyle(color: textColor, fontSize: 17);

  Color get error => categoryColors.first;
  TextStyle get errorText => TextStyle(color: error);
  TextStyle get searchBoxTextStyle => TextStyle(color: textColor, fontSize: 16);
  TextStyle get headerTextStyle => TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20);
  Color get focusedItemBackground => kagiYellow.withAlpha(60);

  @override
  bool operator ==(Object other) =>
      other is ThemeData && background == other.background && textColor == other.textColor;

  @override
  int get hashCode => Object.hash(background, textColor);
}

class KiteThemeWrapper extends StatefulWidget {
  const KiteThemeWrapper(this.initialBrightness, {required this.builder, super.key});
  final ThemeBrightness initialBrightness;
  final WidgetBuilder builder;

  @override
  State<KiteThemeWrapper> createState() => _KiteThemeWrapperState();
}

class _KiteThemeWrapperState extends State<KiteThemeWrapper> {
  late ThemeBrightness _brightness;

  @override
  void initState() {
    super.initState();
    _brightness = widget.initialBrightness;
  }

  @override
  Widget build(BuildContext context) {
    return KiteTheme(
      ThemeData(_brightness),
      () => setState(
        () =>
            _brightness = switch (_brightness) {
              ThemeBrightness.dark => ThemeBrightness.light,
              ThemeBrightness.light => ThemeBrightness.dark,
            },
      ),
      child: Builder(builder: widget.builder),
    );
  }
}

class KiteTheme extends InheritedWidget {
  const KiteTheme(this.data, this._toggleTheme, {required super.child, super.key});
  final ThemeData data;
  final VoidCallback _toggleTheme;

  static ThemeData of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<KiteTheme>()!.data;

  static void toggleTheme(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<KiteTheme>()!._toggleTheme();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => oldWidget is KiteTheme && data != oldWidget.data;

  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
}
