import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_api/games_api.dart';
import 'package:video_game_tracker/bloc/game_info_blocs/tab_bar_cubit/tab_bar_state.dart';

class TabBarCubit extends Cubit<TabBarState> {

  TabBarCubit() : super(const TabBarState(index: 0));

  void initializeLists(GameModel game) {
    List<String> modes = game.modes.map((mode) => mode.name,).toList();
    List<String> genres = game.genres.map((genre) => genre.name,).toList();
    List<String> engines = game.gameEngines.map((engine) => engine.name,).toList();
    List<String> companies = game.involvedCompanies.map((company) => company.name,).toList();
    List<String> alternativeNames = game.alternativeNames.map((name) => name.name,).toList();
    List<String> languageSupports = game.languageSupports.map((language) => language.name,).toList();
    List<String> releaseDates = game.releaseDates.map((date) => date.date,).toList();
    List<String> playerPerspectives = game.playerPerspectives.map((perspective) => perspective.name,).toList();
    List<String> themes = game.themes.map((theme) => theme.name,).toList();
    List<String> platforms = game.platforms.map((platform) => platform.name,).toList();

    emit(state.copyWith(
      modes: modes,
      genres: genres,
      engines: engines,
      companies: companies,
      alternativeNames: alternativeNames,
      languageSupports: languageSupports,
      releaseDates: releaseDates,
      playerPerspectives: playerPerspectives,
      themes: themes,
      platforms: platforms
    ));
  }

  void changeIndex(int newIndex) {
    emit(state.copyWith(index: newIndex));
  }
}