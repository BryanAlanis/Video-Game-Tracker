import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/carousel_view_UI_bloc/carousel_view_bloc.dart';
import 'package:video_game_tracker/util/styles.dart';
import '../../../widgets/user_interaction_bar.dart';

///
/// BottomSheetBuilder
///
/// Builds the bottom sheet that displays the current game title and
/// release date. It also displays the UserInteractionBar so the user
/// can like, rate, mark as played or play later.
///
class BottomSheetBuilder extends StatelessWidget {
  final GameModel game;
  const BottomSheetBuilder({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Column(
        children: [
          ListTile(
            title: Text(game.name,),
            subtitle: Text('${game.firstReleaseDate.year}'),
          ),
          Divider(color: getWhiteOpacityColor(),),
          BlocProvider.value(
            value: context.read<CarouselViewBloc>(),
            child: const UserInteractionBar()
          )
        ],
      ),
    );
  }
}