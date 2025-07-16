import 'package:flutter/material.dart';

class NumberedCircle extends StatelessWidget {
  final Alignment alignment;
  final double outerCircleRadius;
  final double innerCircleRadius;
  final int index;

  const NumberedCircle({
    super.key,
    required this.alignment,
    required this.outerCircleRadius,
    required this.innerCircleRadius,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: alignment,
        child: CircleAvatar(
          radius: outerCircleRadius,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: CircleAvatar(
              radius: innerCircleRadius,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                '${index + 1}',
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              )
          ),
        )
    );
  }
}
