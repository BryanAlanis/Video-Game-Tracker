import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_game_tracker/bloc/list_screen_blocs/edit_list_bloc/edit_list_bloc.dart';
import 'package:video_game_tracker/bloc/list_screen_blocs/edit_list_bloc/edit_list_events.dart';
import 'package:video_game_tracker/util/styles.dart';

class DescriptionScreen extends StatefulWidget {

  const DescriptionScreen({super.key,});

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Description'),
        leading: BackButton(
          onPressed: () {
            /// update the description
            context.read<EditListBloc>().add(UpdateDescriptionEvent(
                descriptionController.text
            ));
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getEdgePadding()),
          child: TextField(
            controller: descriptionController,
            autofocus: true,
            maxLines: null, /// Unlimited number of lines
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}