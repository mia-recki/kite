import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

enum KiteThemeBrightness {
  dark(ThemeData(_Colors.kagiYellow, _Colors.black, _Colors.white, Color(0xFFD14900), _Colors.categoryColors)),
  light(ThemeData(_Colors.kagiYellow, _Colors.white, _Colors.black, Color(0xFFD14900), _Colors.categoryColors));

  const KiteThemeBrightness(this._data);

  final ThemeData _data;
}

class ThemeData {
  final Color kagiYellow;
  final Color background;
  final Color textColor;
  final List<Color> categoryColors;
  final Color error;

  TextStyle get errorText => TextStyle(color: error);
  TextStyle get searchBoxTextStyle => TextStyle(color: textColor, fontSize: 16);
  Color get focusedItemBackground => kagiYellow.withAlpha(60);

  KiteThemeBrightness get brightness =>
      this == KiteThemeBrightness.light._data ? KiteThemeBrightness.light : KiteThemeBrightness.dark;

  const ThemeData(this.kagiYellow, this.background, this.textColor, this.error, this.categoryColors);

  @override
  bool operator ==(Object other) =>
      other is ThemeData &&
      kagiYellow == other.kagiYellow &&
      background == other.background &&
      textColor == other.textColor &&
      error == other.error &&
      const DeepCollectionEquality().equals(categoryColors, other.categoryColors);

  @override
  int get hashCode => Object.hash(kagiYellow, background, textColor, error, categoryColors);
}

class KiteThemeWrapper extends StatefulWidget {
  const KiteThemeWrapper(this.initialBrightness, {required this.builder, super.key});
  final KiteThemeBrightness initialBrightness;
  final WidgetBuilder builder;

  @override
  State<KiteThemeWrapper> createState() => _KiteThemeWrapperState();
}

class _KiteThemeWrapperState extends State<KiteThemeWrapper> {
  late KiteThemeBrightness _brightness;

  @override
  void initState() {
    super.initState();
    _brightness = widget.initialBrightness;
  }

  @override
  Widget build(BuildContext context) {
    return KiteTheme(
      _brightness._data,
      () => setState(
        () =>
            _brightness = switch (_brightness) {
              KiteThemeBrightness.dark => KiteThemeBrightness.light,
              KiteThemeBrightness.light => KiteThemeBrightness.dark,
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
}

class _Colors {
  static const kagiYellow = Color(0xFFF3B644);

  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);

  static const categoryColors = [
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
}
