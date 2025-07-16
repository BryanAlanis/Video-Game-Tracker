import 'package:flutter/material.dart';

///
/// Widget used for displaying portions of text when it is too large.
/// Part of the text is displayed initially and the rest of the text is
/// displayed when it is tapped once.
///
/// Takes in a text String and returns a widget
///
class ExpandedText extends StatefulWidget {
  final String text;
  final int? maxLines;

  const ExpandedText({
    super.key,
    required this.text,
    this.maxLines
  });

  @override
  State<ExpandedText> createState() => _ExpandTextState();
}

class _ExpandTextState extends State<ExpandedText> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Column(
        children: [
          /// Text
          if (widget.text.length < 160)
            Text(
              widget.text,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: widget.maxLines,
            )
          else
            Text(
              expanded ? widget.text : "${widget.text.substring(0,160)}...",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          /// Show more Icon
          if (expanded || widget.text.length < 160)
            const SizedBox(height: 10, width: 0,)
          else
            const Icon(Icons.more_horiz, size: 30,)
        ],
      )
    );
  }
}