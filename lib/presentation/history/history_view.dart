import 'package:flutter/widgets.dart';

import '../../data/models/history.dart';
import '../../theme/components/section_view.dart';
import '../cluster/components/timeline_view.dart';

class HistoryView extends StatelessWidget {
  const HistoryView(this.history, {super.key});
  final History history;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SectionView('Events', child: TimelineView(history.events.map((e) => (e.year, e.content)).toList())),
        SectionView('People', child: TimelineView(history.people.map((e) => (e.year, e.content)).toList())),
      ],
    );
  }
}
