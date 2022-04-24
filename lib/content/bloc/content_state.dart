part of 'content_bloc.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object> get props => [];
}

class ContentInitial extends ContentState {}

class ContentGetFavMusicSuccess extends ContentState {
  final List<dynamic> favourites;

  ContentGetFavMusicSuccess({required this.favourites});

  @override
  List<Object> get props => [this.favourites];
}

class ContentGetFavMusicError extends ContentState {}

class ContentGetFavMusicIsEmpty extends ContentState {}

class ContentGetFavMusicLoading extends ContentState {}

class ContentAddFavSongLoading extends ContentState {}

class ContentAddFavSongSuccess extends ContentState {}

class ContentAddFavSongError extends ContentState {}

class ContentAddFavSongExists extends ContentState {}

class ContentRemoveFavSongLoading extends ContentState {}

class ContentRemoveFavSongSuccess extends ContentState {}

class ContentRemoveFavSongError extends ContentState {}
