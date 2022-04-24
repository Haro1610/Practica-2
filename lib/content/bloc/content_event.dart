part of 'content_bloc.dart';

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object> get props => [];
}

class GetFavouriteMusicEvent extends ContentEvent {}

class RemoveFavouriteMusicEvent extends ContentEvent {
  final int index;

  RemoveFavouriteMusicEvent({required this.index});
  @override
  List<Object> get props => [this.index];
}

class AddFavouriteMusicEvent extends ContentEvent {
  final Map<String, dynamic> favourite;

  AddFavouriteMusicEvent({required this.favourite});
  @override
  List<Object> get props => [this.favourite];
}
