import 'package:flutter/widgets.dart';

import '../../../theme/components/header_text.dart';
import '../../../theme/kite_theme.dart';

class TalkingPointsView extends StatelessWidget {
  const TalkingPointsView(this.title, this.talkingPoints, {super.key});

  final String title;
  final List<(String, String)> talkingPoints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderText(title),
        const _DashedDivider(),
        for (final (i, point) in talkingPoints.indexed)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DefaultTextStyle(
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: KiteTheme.of(context).textColor),
                child: Row(
                  spacing: 16,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: KiteTheme.of(context).talkingPointCircleBg,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          (i + 1).toString(),
                          style: TextStyle(color: KiteTheme.of(context).talkingPointCircleText),
                        ),
                      ),
                    ),
                    Text(point.$1),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(point.$2),
              const SizedBox(height: 12),
              const _DashedDivider(),
            ],
          ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: CustomPaint(painter: _DashedDividerPainter(dividerColor: KiteTheme.of(context).talkingPointsDivider)),
    );
  }
}

class _DashedDividerPainter extends CustomPainter {
  static const _dashWidth = 4.0;
  final Color dividerColor;

  _DashedDividerPainter({required this.dividerColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = dividerColor
          ..strokeWidth = 1;

    Path path = Path();
    path.moveTo(0, size.height / 2); // Start point
    path.lineTo(size.width - 10.0, size.height / 2); // End point

    var startX = 0.0;

    while (startX <= size.width) {
      canvas.drawLine(Offset(startX, size.height / 2), Offset(startX + _dashWidth, size.height / 2), paint);
      startX += _dashWidth * 2;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
