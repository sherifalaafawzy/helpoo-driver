import 'package:flutter/material.dart';
import 'package:helpoo/service_request/core/util/constants.dart';
import 'package:helpoo/service_request/core/util/extensions/days_extensions.dart';

class InspectorItemCard extends StatelessWidget {
  final String title;
  final bool selected;

  const InspectorItemCard(
      {Key? key, required this.title, required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          borderRadius: 10.br,
          color: selected ? mainColorHex.withOpacity(0.4) : Colors.white,
          border: Border.all(width: 1.5, color: selected ? mainColorHex : Colors.grey.shade300)),
      child: Row(
        children: [
          animatedCrossFadeWidget(
              animationStatus: selected,
              shownIfTrue: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: mainColorHex,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              shownIfFalse: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300)),
              )),
          space20Horizontal(),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: selected ? Colors.white : Colors.black),
            // style: TextStyles.title14_500
            //     .copyWith(color: Colors.black),
          )
        ],
      ),
    );
  }

  Widget animatedCrossFadeWidget({
    required bool animationStatus,
    required Widget shownIfFalse,
    required Widget shownIfTrue,
    VoidCallback? onPressed,
    Duration? duration,
    Curve firstCurve = Curves.easeIn,
    Curve sizeCurve = Curves.easeInOut,
  }) {
    return InkWell(
      onTap: onPressed,
      child: AnimatedCrossFade(
        firstChild: shownIfFalse,
        secondChild: shownIfTrue,
        crossFadeState: animationStatus
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        firstCurve: firstCurve,
        sizeCurve: sizeCurve,
      ),
    );
  }
}
