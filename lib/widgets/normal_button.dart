import 'package:flutter/material.dart';

class NormalButton extends StatelessWidget {
  final double width;
  final EdgeInsetsGeometry? padding;
  final String text;
  final void Function()? onPressed;

  const NormalButton({
    super.key,
    required this.width,
    this.padding,
    required this.text,
    required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        padding: padding,
        child: FilledButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith((states) {
              return Theme.of(context).colorScheme.primary;
            },)
          ),
          onPressed: onPressed,
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge,)
        )
    );
  }
}
