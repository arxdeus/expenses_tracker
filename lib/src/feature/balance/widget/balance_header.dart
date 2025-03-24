import 'package:app_core/app_core.dart' as core;
import 'package:expenses_tracker/src/feature/balance/modules/balance_updates_module.dart';
import 'package:expenses_tracker/src/shared/effects/size_fade_transition.dart';
import 'package:flutter/material.dart';
import 'package:modulisto_flutter/modulisto_flutter.dart';
import 'package:resources/_assets/assets.gen.dart';
import 'package:resources/resources.dart';

class SomeNotifier with core.ChangeNotifier {
  int x = 0;

  void xdd() {
    x++;
    notifyListeners();
  }
}

class NotifierWrapper2 extends SomeNotifier implements Listenable {}

class BalanceWithGraph extends StatefulWidget {
  const BalanceWithGraph({
    super.key,
  });

  @override
  State<BalanceWithGraph> createState() => _BalanceWithGraphState();
}

class _BalanceWithGraphState extends State<BalanceWithGraph> {
  late final _module = ModuleScope.of<BalanceUpdatesModule>(context);
  late final _graphVisibilityState = ValueNotifier(false);
  final xx = NotifierWrapper2();

  @override
  void dispose() {
    _graphVisibilityState.dispose();
    _module.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    xx.addListener(() => print(xx));
    xx.xdd();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        FractionallySizedBox(
          widthFactor: .7,
          child: FittedBox(
            alignment: Alignment.topLeft,
            child: Text(
              'Баланс',
              textAlign: TextAlign.start,
              style: TextStyle(
                height: 1,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeCap = StrokeCap.square
                  ..color = Colors.grey.shade200,
                fontSize: 256,
                letterSpacing: 1,
                fontWeight: FontWeight.w500,
                fontFamily: FontFamily.euclidFlex,
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 16),
              child: FractionallySizedBox(
                widthFactor: .55,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Баланс',
                    style: TextStyle(
                      height: 1,
                      fontFamily: FontFamily.euclidFlex,
                      color: Colors.black,
                      fontSize: 256,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _graphVisibilityState.value = !_graphVisibilityState.value;
              },
              child: StoreBuilder(
                unit: _module.state,
                builder: (context, balance, _) {
                  final bool isPositiveTransaction =
                      !(balance?.integerValue.sign.isNegative ?? false);
                  final String transactionSign = isPositiveTransaction ? r'$' : r'-$';
                  return Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: balance == null
                            ? core.TextPlaceholder()
                            : Text(
                                balance.toStringWithPrefix(
                                  prefix: transactionSign,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: isPositiveTransaction ? null : Colors.redAccent,
                                  fontFamily: FontFamily.comfortaa,
                                  fontSize: 48,
                                ),
                              ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.bar_chart_rounded,
                        size: 32,
                      ),
                    ],
                  );
                },
              ),
            ),
            ListenableBuilder(
              listenable: xx,
              builder: (context, _) => SizeFadeExplicitTransition(
                isExpanded: true,
                curve: Curves.easeIn,
                child: Assets.images.graph.image(
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
