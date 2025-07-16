import 'package:flutter/material.dart';
import 'package:video_game_tracker/util/styles.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Icon prefixIcon;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final bool? enabled;
  final bool? obscureText;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.textEditingController,
    this.focusNode,
    this.enabled,
    this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText ?? false,
      focusNode: focusNode,
      controller: textEditingController,
      cursorColor: Theme.of(context).colorScheme.primary,
      cursorHeight: 25,
      textAlignVertical: TextAlignVertical.center,
      style: Theme.of(context).textTheme.titleMedium,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        enabled: enabled ?? true,
        fillColor: Theme.of(context).colorScheme.secondary,
        prefixIcon: prefixIcon,
        prefixIconColor: Theme.of(context).colorScheme.onSurface,
        suffixIcon: IconButton(
          icon: Icon(Icons.cancel, color: Theme.of(context).colorScheme.onSurface,),
          onPressed: () => textEditingController?.clear(),
        ),
        suffixIconColor: Theme.of(context).colorScheme.surface,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(getBorderRadius(factor: 2))
        ),
      ),
    );
  }
}
