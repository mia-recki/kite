import 'package:flutter/widgets.dart';

import '../data/models/cluster.dart';
import '../data/models/content.dart';
import '../data/models/history.dart';
import '../theme/components/back_gesture_detector.dart';
import '../theme/components/kite_logo.dart';
import '../utils/screen_utils.dart';
import '../view_model/actions/intents.dart';
import 'cluster/cluster_view.dart';
import 'history/history_view.dart';

class ContentView extends StatelessWidget {
  ContentView(this.content) : super(key: ValueKey(content));
  final Content? content;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: screenSizeBreakpoint),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (_, _) => Actions.handler(context, const GoBackIntent())?.call(),
        child: BackGestureDetector(
          onBackGesture: Actions.handler(context, const GoBackIntent()),
          child: switch (content) {
            final Cluster cluster => ClusterView(cluster),
            final History history => HistoryView(history),
            _ => const KiteLogo(),
          },
        ),
      ),
    );
  }
}
