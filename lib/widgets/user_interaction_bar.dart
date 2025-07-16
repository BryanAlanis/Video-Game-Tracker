import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/app_wide_blocs/carousel_view_UI_bloc/carousel_view_bloc.dart';
import '../bloc/app_wide_blocs/carousel_view_UI_bloc/carousel_view_events.dart';
import '../bloc/app_wide_blocs/carousel_view_UI_bloc/carousel_view_state.dart';
import '../screens/profile screens/log_in_screen.dart';
import '../util/styles.dart';
import 'custom_rating_bar.dart';

class UserInteractionBar extends StatelessWidget {
  const UserInteractionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarouselViewBloc, CarouselViewState>(
      bloc: context.read<CarouselViewBloc>(),
      builder: (context, state) {
        /// Disable buttons if user is not singed in
        if(!state.isLoggedIn) {
          return GestureDetector(
              onTap: () => showCustomDialog(context),
              child: InteractionButtonsRow(isDisabled: state.isLoggedIn,)
          );
        }
        /// Show rating bar if the user taps on the rating button
        else if (state.status == StateStatus.showRatingBar) {
          return  BlocProvider<CarouselViewBloc>.value(
            value: context.read<CarouselViewBloc>(),
            child: CustomRatingBar(
              initialRating: state.interactions.ratings
              [state.gameID.toString()] ?? 0,
              gameID: state.gameID
            ),
          );
        }
        /// Show regular interactions bar
        else if (state.status == StateStatus.showInteractions) {
          return BlocProvider<CarouselViewBloc>.value(
            value: context.read<CarouselViewBloc>(),
            child: InteractionButtonsRow(
              isDisabled: !state.isLoggedIn,
              played: state.played,
              playLater: state.playLater,
              liked: state.liked,
              rating: state.rating,
            ),
          );
        }
        /// Error
        else if (state.status == StateStatus.error) {
          return const Center(
            child: Text('There was an error when getting your interactions'),
          );
        }
        /// Show loading icon
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  ///Ask the user to log in if they want to like, rate, etc, their  games
  Future<void> showCustomDialog(BuildContext context,) async {
    return showDialog (
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign In'),
          content: const Text('Sign In to continue'),
          actions: [
            TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogInScreen(shouldPopContext: false,))
                ),
                child: const Text('Sign In')
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')
            ),
          ],
        );
      }
    );
  }
}

///
/// InteractionButtonsRow
///
/// This widget provides a row of icon buttons that allow
/// the user to interact with a specific game.
/// A game can be marked as played, liked, play later, or rated by the user.
///
/// It uses the UserDB bloc to make changes to the UI as well as update the
/// FireStore database once the user leaves the current screen to minimize
/// the number of reads and writes.
///
///
class InteractionButtonsRow extends StatelessWidget {
  final bool isDisabled, played, playLater, liked;
  final double rating;

  const InteractionButtonsRow({
    super.key,
    required this.isDisabled,
    this.played = false,
    this.playLater = false,
    this.liked = false,
    this.rating = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CarouselViewBloc>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        /*** Played button ***/
        CustomIconButton(
          color: played ? getGreenColor() : getWhiteColor(),
          label: played ? 'Played' : 'Play',
          icon:played ? CupertinoIcons.gamecontroller_fill
            : CupertinoIcons.gamecontroller,
          onPressed: isDisabled ? null :
            () {
              played ? bloc.add(RemovePlayedEvent(bloc.state.gameID))
              : bloc.add(PlayedEvent(bloc.state.gameID));
            },
        ),
        /*** Liked button ***/
        CustomIconButton(
          color: liked ? getRedColor() : getWhiteColor(),
          label: liked ? 'Liked' : 'Like',
          icon: liked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
          onPressed: isDisabled ? null :
            (){
              liked ? bloc.add(RemoveLikeEvent(bloc.state.gameID))
              : bloc.add(LikeEvent(bloc.state.gameID));
            },
        ),
        /*** Play Later button ***/
        CustomIconButton(
          color: playLater ? getBlueColor() : getWhiteColor(),
          label: 'Play Later',
          icon: playLater ? CupertinoIcons.clock_fill : CupertinoIcons.clock,
          onPressed: isDisabled ? null :
            (){
              playLater ? bloc.add(RemovePlayLaterEvent(bloc.state.gameID))
              : bloc.add(PlayLaterEvent(bloc.state.gameID));
            },
        ),
        /*** Rate button ***/
        CustomIconButton(
          color: rating != 0 ? getYellowColor() : getWhiteColor(),
          label:rating != 0 ? 'Rated $rating' : 'Rate',
          icon: rating != 0 ? CupertinoIcons.star_fill : CupertinoIcons.star,
          onPressed: isDisabled ? null :
            (){
              bloc.add(ShowRatingBarEvent(bloc.state.gameID));
            },
        ),
      ],
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final Color? color;
  final String label;
  final IconData icon;
  final void Function()? onPressed;

  const CustomIconButton({
    super.key,
    this.color,
    required this.label,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          alignment: Alignment.center,
          iconSize: 50,
          color: color ?? getWhiteColor(),
          tooltip: label,
          onPressed: onPressed,
          icon: Icon(icon),
        ),
        Text(label, style: Theme.of(context).textTheme.labelMedium,)
      ],
    );
  }
}