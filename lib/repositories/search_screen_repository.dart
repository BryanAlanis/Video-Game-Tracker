import 'package:games_api/games_api.dart';

class SearchScreenRepository {

  final Map<String, List<String>> categories = {
    'Genres': ['Adventure', 'Shooter', 'RPG', 'Indie', 'Music', 'Sport', 'Fighting'],
    'Platforms': ['PlayStation 5', 'Xbox Series X|S', 'PC (Microsoft Windows)', 'Nintendo Switch', 'Xbox 360', 'PlayStation 4', 'PlayStation 3'],
    'Release Years': ['2020s', '2010s', '2000s', '1990s'],
    'Modes': ['Single player', 'Multiplayer', 'Battle Royale', 'Co-operative', 'Split screen'],
    'Themes': ['Action', 'Comedy', 'Drama', 'Fantasy', 'Horror', 'Survival', 'Stealth', 'Thriller', 'Science fiction', 'Open world'],
    'Perspectives': ['First Person', 'Third Person', 'Virtual Reality', 'Side View'],
    'Companies': ['Bethesda Softworks','Capcom', 'Electronic Arts', 'Epic Games', 'FromSoftware', 'Insomniac Games', 'Nintendo', 'Sega', 'Sony Interactive Entertainment', 'Xbox Game Studios'],
    'ESRB Rating': ['Rating Pending', 'Everyone', 'Everyone 10+', 'Teen', 'Mature',],
    'Game Engines': ['RE Engine', 'RenderWare', 'Source', 'Unity', 'Unreal Engine', ],
    'Language Supports': ['Chinese', 'English', 'French', 'German', 'Italian', 'Japanese', 'Korean', 'Polish', 'Portuguese', 'Russian', 'Spanish']
  };

  final List<GameModel> games;

  SearchScreenRepository({required this.games});

  List<GameModel> getFilteredList(int index, String title) {
    List<GameModel> filteredList = [];
    List<String> specificCategories = categories[title] ?? [];

    if (title == 'Genres'){
      filteredList = games.where(
        (game) => game.genres.where(
          (genre) => genre.name == specificCategories[index]).isNotEmpty).toList();
    }
    else if (title == 'Platforms'){
      filteredList = games.where(
        (game) => game.platforms.where(
          (platform) => platform.name == specificCategories[index]).isNotEmpty).toList();
    }
    else if (title == 'Release Years'){
      /// Get the desired decade as an integer
      int decade = int.parse(specificCategories[index].substring(0, specificCategories[index].length-1));
      filteredList = games.where(
        /// decade <= release date < decade + 10
        (game) => game.firstReleaseDate.year >= decade && game.firstReleaseDate.year < decade+10).toList();
    }
    else if (title == 'Modes'){
      filteredList = games.where(
        (game) => game.modes.where(
          (mode) => mode.name == specificCategories[index]).isNotEmpty).toList();
    }
    else if (title == 'Themes'){
      filteredList = games.where(
        (game) => game.themes.where(
          (theme) => theme.name == specificCategories[index]).isNotEmpty).toList();
    }
    ///Difference in capitalization
    else if (title == 'Perspectives') {
      filteredList = games.where(
        (game) => game.playerPerspectives.where(
          (perspective) => perspective.name == specificCategories[index]).isNotEmpty).toList();
    }
    else if (title == 'Companies') {
      filteredList = games.where(
        (game) => game.involvedCompanies.where(
          (company) => company.name == specificCategories[index]).isNotEmpty).toList();
    }
    else if (title == 'ESRB Rating') {
      filteredList = games.where(
        (game) => game.ageRatings.where(
          (rating) {
            switch (specificCategories[index]) {
              case 'Rating Pending':
                return rating.rating == 'RP';
              case 'Everyone':
                return rating.rating == 'E';
              case 'Everyone 10+':
                return rating.rating == 'E10+';
              case 'Teen':
                return rating.rating == 'T';
              case 'Mature':
                return rating.rating == 'M';
              default:
                return false;
            }
          }).isNotEmpty).toList();
    }
    else if (title == 'Game Engines') {
      filteredList = games.where(
        (game) => game.gameEngines.where(
          (engine) => engine.name == specificCategories[index]).isNotEmpty).toList();
    }
    else if (title == 'Language Supports') {
      filteredList = games.where(
        (game) => game.languageSupports.where(
          (language) => language.name == specificCategories[index]).isNotEmpty).toList();
    }
    return filteredList;
  }
}