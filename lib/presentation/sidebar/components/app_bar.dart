import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../theme/components/images.dart';
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
          ConstrainedBox(constraints: const BoxConstraints(maxWidth: 48, maxHeight: 48), child: kiteLogo),
          const Text('Kite', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          // TODO: put somewhere else
          Expanded(child: Text(DateFormat('EEEE, MMMM dd').format(DateTime.now()), textAlign: TextAlign.center)),
          GestureDetector(
            onTap: Actions.handler(context, ToggleThemeIntent()),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: SvgPicture.asset(
                themeBrightnessAsset,
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
