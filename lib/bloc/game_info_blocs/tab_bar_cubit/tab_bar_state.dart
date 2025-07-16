import 'package:equatable/equatable.dart';

class TabBarState extends Equatable {
  final List<String> modes;
  final List<String> genres;
  final List<String> engines;
  final List<String> companies;
  final List<String> alternativeNames;
  final List<String> languageSupports;
  final List<String> releaseDates;
  final List<String> playerPerspectives;
  final List<String> themes;
  final List<String> platforms;
  final int index;

  const TabBarState({
    required this.index,
    this.modes = const [],
    this.genres = const [],
    this.engines = const [],
    this.companies = const [],
    this.alternativeNames = const [],
    this.languageSupports = const [],
    this.releaseDates = const [],
    this.playerPerspectives = const [],
    this.themes = const [],
    this.platforms = const [],
  });

  TabBarState copyWith({
    int? index,
    List<String>? modes,
    List<String>? genres,
    List<String>? engines,
    List<String>? companies,
    List<String>? alternativeNames,
    List<String>? languageSupports,
    List<String>? releaseDates,
    List<String>? playerPerspectives,
    List<String>? themes,
    List<String>? platforms
  }) {
    return TabBarState(
      index: index ?? this.index,
      modes: modes ?? this.modes,
      genres: genres ?? this.genres,
      engines: engines ?? this.engines,
      companies: companies ?? this.companies,
      alternativeNames: alternativeNames ?? this.alternativeNames,
      languageSupports: languageSupports ?? this.languageSupports,
      releaseDates: releaseDates ?? this.releaseDates,
      playerPerspectives: playerPerspectives ?? this.playerPerspectives,
      themes: themes ?? this.themes,
      platforms: platforms ?? this.platforms
    );
  }

  @override
  List<Object?> get props => [
    index,
    modes,
    genres,
    engines,
    companies,
    alternativeNames,
    languageSupports,
    releaseDates,
    playerPerspectives,
    themes,
    platforms
  ];
}