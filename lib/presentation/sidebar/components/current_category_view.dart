import 'package:flutter/widgets.dart';

import '../../../data/models/category.dart';
import '../../../theme/components/button.dart';
import '../../../view_model/actions/intents.dart';
import '../../../view_model/kite_view_model.dart';
import '../../../view_model/provider/kite_provider.dart';

class CurrentCategoryView extends StatelessWidget {
  const CurrentCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ValueListenableBuilder(
        valueListenable: KiteProvider.of<KiteViewModel>(context).currentCategory,
        builder:
            (context, category, _) => switch (category) {
              null => const SizedBox(),
              final Category category => Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button(
                      onTap: Actions.handler(context, GoLeftIntent()),
                      text: '<',
                      semanticsLabel: 'Previous category',
                    ),
                    GestureDetector(
                      onTap: Actions.handler(context, ToggleCategoriesListIntent()),
                      child: Text(category.name),
                    ),
                    Button(
                      onTap: Actions.handler(context, GoRightIntent()),
                      text: '>',
                      semanticsLabel: 'Next category',
                    ),
                  ],
                ),
              ),
            },
      ),
    );
  }
}
