import 'package:flutter/widgets.dart';

import 'images.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this)
    ..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, -0.5),
    end: const Offset(0.0, 0.5),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutSine));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _offsetAnimation, child: kiteLogo);
  }
}
