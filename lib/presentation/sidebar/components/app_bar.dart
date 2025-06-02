import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../theme/components/kite_logo.dart';
import '../../../theme/kite_theme.dart';
import '../../../view_model/actions/intents.dart';

class AppBar extends StatelessWidget {
  const AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Row(
        children: [
          const KiteLogo(width: 40, height: 40),
          const Text('Kite', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          Expanded(child: Text(DateFormat('EEEE, MMMM dd').format(DateTime.now()), textAlign: TextAlign.center)),
          GestureDetector(
            onTap: Actions.handler(context, const ToggleThemeIntent()),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: SvgPicture.asset(
                'assets/img/dark-theme.svg',
                fit: BoxFit.fitHeight,
                colorFilter: ColorFilter.mode(KiteTheme.of(context).textColor, BlendMode.srcIn),
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
