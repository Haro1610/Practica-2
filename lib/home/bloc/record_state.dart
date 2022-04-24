part of 'record_bloc.dart';

abstract class RecordState extends Equatable {
  const RecordState();

  @override
  List<Object> get props => [];
}

class RecordInitial extends RecordState {}

class RecordListeningState extends RecordState {}

class RecordFinishedState extends RecordState {}

class RecordMissingValuesState extends RecordState {}

class RecordErrorState extends RecordState {}

class RecordSuccessState extends RecordState {
  String song;

  String artist;

  String album;

  String releaseDate;

  String appleMussic;

  String spotify;

  String albumCover;

  String listenLink;

  RecordSuccessState({
    required this.song,
    required this.artist,
    required this.album,
    required this.releaseDate,
    required this.appleMussic,
    required this.spotify,
    required this.albumCover,
    required this.listenLink,
  });
}
