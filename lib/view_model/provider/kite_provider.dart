import 'package:flutter/widgets.dart';

import '../../data/kite_service.dart';
import '../kite_view_model.dart';

/// Provides access to [KiteViewModel] and [KiteService]
// NOTE: as the app grows in complexity, it would require more robust dependency injection solution
class KiteProvider extends InheritedWidget {
  const KiteProvider({required this.service, required this.viewModel, required super.child, super.key});
  final KiteViewModel viewModel;
  final KiteService service;

  static T of<T>(BuildContext context) {
    if (T == KiteViewModel) {
      return context.dependOnInheritedWidgetOfExactType<KiteProvider>()!.viewModel as T;
    }
    if (T == KiteService) {
      return context.dependOnInheritedWidgetOfExactType<KiteProvider>()!.service as T;
    }
    throw Exception('$KiteProvider cannot provide $T');
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
