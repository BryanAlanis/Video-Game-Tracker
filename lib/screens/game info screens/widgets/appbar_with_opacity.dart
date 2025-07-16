import 'package:flutter/material.dart';

///
/// AppBarWithOpacity
///
/// This appbar appears as the user scrolls down by
/// changing the opacity depending on the scroll offset. The title is displayed
/// after a certain scroll offset as well.
///
/// The widget must be a separate widget to avoid rebuilding the entire
/// screen everytime the user scrolls.
///
/// Input: scrollController, title, offset limits
/// Output: preferredSizeWidget appbar
///

class AppBarWithOpacity extends StatefulWidget implements PreferredSizeWidget{
  final ScrollController scrollController;
  final String title;
  final double transitionOffset;
  final List<Widget>? actions;

  const AppBarWithOpacity({
    super.key,
    required this.scrollController,
    required this.title,
    required this.transitionOffset,
    this.actions,
  });

  @override
  State<AppBarWithOpacity> createState() => _AppBarWithOpacityState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _AppBarWithOpacityState extends State<AppBarWithOpacity> {
  String _appBarText = '';
  bool _transparentAppbar = true;

  ///
  /// Used to change AppBar appearance when scrolling
  ///
  void _scrollListener (){
    /// Color and title should be visible
    if (widget.scrollController.offset > widget.transitionOffset &&
        widget.scrollController.offset < widget.transitionOffset + 100) {
      _appBarText = widget.title;
      _transparentAppbar = false;
      setState(() {});
    }
    /// Color and title should not be visible
    else if (widget.scrollController.offset < widget.transitionOffset &&
        widget.scrollController.offset > widget.transitionOffset - 100) {
      _appBarText = '';
      _transparentAppbar = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    widget.scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_appBarText, style: Theme.of(context).textTheme.titleLarge),
      backgroundColor: _transparentAppbar ? Colors.transparent :
          Theme.of(context).colorScheme.primary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: CircleAvatar(
          backgroundColor: _transparentAppbar ? Colors.black45 :
              Theme.of(context).colorScheme.primary,
          child: BackButton(
            onPressed: () => Navigator.pop(context),
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      /// Take the list of actions and wrap them with a CircleAvatar
      /// that will have a translucent background when appbar is transparent
      actions: List.generate(
        widget.actions?.length ?? 0,
        (index) {
          return CircleAvatar(
            backgroundColor: _transparentAppbar ? Colors.black45 :
            Theme.of(context).colorScheme.primary,
            child: widget.actions?[index],
          );
        },
      )
    );
  }
}
