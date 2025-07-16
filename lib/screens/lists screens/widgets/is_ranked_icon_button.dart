import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/list_screen_blocs/edit_list_bloc/edit_list_bloc.dart';
import '../../../bloc/list_screen_blocs/edit_list_bloc/edit_list_events.dart';
import '../../../bloc/list_screen_blocs/edit_list_bloc/edit_list_states.dart';

class IsRankedIconButton extends StatelessWidget {

  const IsRankedIconButton({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<EditListBloc, EditListState, bool>(
      selector: (state) => state.isRanked,
      builder: (context, isRanked) {
        return GestureDetector(
          onTap: () {
            context.read<EditListBloc>().add(UpdateIsRankedEvent(!isRanked));
          },
          child: Column(
            children: [
              Icon(
                isRanked ? Icons.emoji_events : Icons.emoji_events_outlined,
                color: isRanked ? Theme.of(context).colorScheme.primary : Colors.grey,
                size: 40,
              ),
              Text(
                'Ranked',
                style: Theme.of(context).textTheme.titleLarge?.merge(
                    TextStyle(
                        color: isRanked ?
                        Theme.of(context).colorScheme.primary : Colors.grey
                    )
                ),
              )
            ],
          ),
        );
      },
    );
  }
}