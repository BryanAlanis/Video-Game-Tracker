import 'package:games_api/src/models/game_models/age_rating.dart';
import 'package:games_api/src/models/game_models/player_perspective.dart';
import 'game_models/artwork.dart';
import 'game_models/game_engine.dart';
import 'game_models/alternative_name.dart';
import 'game_models/involved_company.dart';
import 'game_models/language_support.dart';
import 'game_models/theme.dart';
import 'game_models/game_mode.dart';
import 'game_models/genre.dart';
import 'game_models/platform.dart';
import 'game_models/screenshot.dart';
import 'game_models/release_date.dart';


class GameModel {
  final int id;
  final List<AgeRatingModel> ageRatings;
  final List<AlternativeNameModel> alternativeNames;
  final List<ArtworkModel> artworks;
  final String cover;
  final DateTime firstReleaseDate;
  final List<GameEngineModel> gameEngines;
  final List<GenreModel> genres;
  final List<InvolvedCompanyModel> involvedCompanies;
  final List<LanguageSupportModel> languageSupports;
  final List<GameModeModel> modes;
  final String name;
  final List<PlatformModel> platforms;
  final List<PlayerPerspectiveModel> playerPerspectives;
  final List<ReleaseDateModel> releaseDates;
  final List<ScreenshotModel> screenshots;
  final String summary;
  final List<ThemeModel> themes;
  final double totalRating;

  GameModel({
    required this.id,
    required this.ageRatings,
    required this.alternativeNames,
    required this.artworks,
    required this.cover,
    required this.firstReleaseDate,
    required this.gameEngines,
    required this.genres,
    required this.involvedCompanies,
    required this.languageSupports,
    required this.modes,
    required this.name,
    required this.platforms,
    required this.playerPerspectives,
    required this.releaseDates,
    required this.screenshots,
    required this.summary,
    required this.themes,
    required this.totalRating,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      ageRatings: (json['ageRatings'] as List).map((rating) => AgeRatingModel.fromJson(rating)).toList(),
      alternativeNames: (json['alternativeNames'] as List).map((name) => AlternativeNameModel.fromJson(name)).toList(),
      artworks: (json['artworks'] as List).map((artwork) => ArtworkModel.fromJson(artwork)).toList(),
      cover: json['cover'],
      /// release date is stored as a unix timestamp. Convert it to date time and extract relevant date
      firstReleaseDate: DateTime.fromMillisecondsSinceEpoch(json['firstReleaseDate'] * 1000, isUtc: true),
      gameEngines: (json['gameEngines'] as List).map((engine) => GameEngineModel.fromJson(engine)).toList(),
      genres: (json['genres'] as List).map((genre) => GenreModel.fromJson(genre)).toList(),
      involvedCompanies: (json['involvedCompanies'] as List).map((company) => InvolvedCompanyModel.fromJson(company)).toList(),
      languageSupports: (json['languageSupport'] as List).map((language) => LanguageSupportModel.fromJson(language)).toList(),
      modes: (json['modes'] as List).map((mode) => GameModeModel.fromJson(mode)).toList(),
      name: json['name'],
      platforms: (json['platforms'] as List).map((platform) => PlatformModel.fromJson(platform)).toList(),
      playerPerspectives: (json['playerPerspectives'] as List).map((perspective) => PlayerPerspectiveModel.fromJson(perspective)).toList(),
      releaseDates: (json['releaseDates'] as List).map((date) => ReleaseDateModel.fromJson(date)).toList(),
      screenshots: (json['screenshots'] as List).map((screenshot) => ScreenshotModel.fromJson(screenshot)).toList(),
      summary: json['summary'],
      themes: (json['themes'] as List).map((theme) => ThemeModel.fromJson(theme)).toList(),
      totalRating: json['totalRating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ageRating': ageRatings,
      'alternativeNames': alternativeNames,
      'artworks': artworks,
      'cover': cover,
      'firstReleaseDate': firstReleaseDate.millisecondsSinceEpoch,
      'gameEngines': gameEngines,
      'genres': genres,
      'involvedCompanies': involvedCompanies,
      'languageSupports': languageSupports,
      'modes': modes,
      'name': name,
      'platforms': platforms,
      'playerPerspectives': playerPerspectives,
      'screenshots': screenshots,
      'summary': summary,
      'themes': themes,
      'totalRating': totalRating,
    };
  }

  @override
  String toString() {
    return name;
  }
}