import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:video_game_tracker/util/styles.dart';
import '../bloc/app_wide_blocs/carousel_view_UI_bloc/carousel_view_bloc.dart';
import '../bloc/app_wide_blocs/carousel_view_UI_bloc/carousel_view_events.dart';

///
/// CustomRatingBar
///
/// This widget uses the flutter_rating_bar package to create a rating bar.
/// The user can rate from 1-5 stars (half stars are allowed) and use the
/// back button to return to the regular interaction bar.
///
/// It is displayed in the same places that the UserInteractionBar is displayed.
/// When the user clicks on the rate button, this widget will be displayed.
///
class CustomRatingBar extends StatelessWidget {
  final int gameID;
  final double initialRating;

  const CustomRatingBar({
    super.key,
    required this.initialRating,
    required this.gameID
  });

  @override
  Widget build(BuildContext context) {
    /// Keep track of the rating so the database can be updated when the user
    /// return to the initial interaction bar.
    double currentRating = 0;

    return Row(
      children: [
        /// SizedBox provides some padding
        const SizedBox(width: 15,),
        /*** Back button ***/
        IconButton(
          iconSize: 40,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final bloc = context.read<CarouselViewBloc>();
            bloc.add(ShowInteractionsBarEvent(gameID, bloc.state.index));
          }
        ),
        /*** Rating bar ***/
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: RatingBar.builder(
              initialRating: initialRating,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                CupertinoIcons.star_fill,
                color: getYellowColor(),
              ),
              onRatingUpdate: (value) {
                currentRating = value;
                if (currentRating == 0) {
                  context.read<CarouselViewBloc>().add(
                      RemoveRatingEvent(gameID));
                }
                /// only write to the database if the rating changed
                else if (currentRating != initialRating) {
                  context.read<CarouselViewBloc>().add(
                      RateEvent(gameID, currentRating));
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}