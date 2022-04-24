import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'content_event.dart';
part 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  ContentBloc() : super(ContentInitial()) {
    on<AddFavouriteMusicEvent>(addFavourite);
    on<RemoveFavouriteMusicEvent>(removeFavourite);
    on<GetFavouriteMusicEvent>(getFavouritesList);
  }
  Future<void> addFavourite(
      AddFavouriteMusicEvent event, Emitter<ContentState> emitter) async {
    emit(ContentAddFavSongLoading());
    try {
      DocumentReference<Map<String, dynamic>> userCollection =
          getUserCollection();

      Map<String, dynamic>? collection = (await userCollection.get()).data();

      if (collection == null) {
        print("Could not retrieve collection");
        return null;
      }
      List<dynamic> favourites = collection['favourites'];
      if (favourites.isEmpty) {
        favourites.add(event.favourite);
        await userCollection.update({'favourites': favourites});
        emit(ContentAddFavSongSuccess());
      } else {
        for (var i in favourites) {
          if (i['song'] == event.favourite['song'] &&
              i['artist'] == event.favourite['artist']) {
            emit(ContentAddFavSongExists());
            return;
          }
        }
        favourites.add(event.favourite);
        await userCollection.update({'favourites': favourites});
        emit(ContentAddFavSongSuccess());
      }
    } catch (e) {
      emit(ContentAddFavSongError());
    }
  }

  Future<void> removeFavourite(
      RemoveFavouriteMusicEvent event, Emitter<ContentState> emitter) async {
    emit(ContentRemoveFavSongLoading());
    try {
      DocumentReference<Map<String, dynamic>> userCollection =
          getUserCollection();

      Map<String, dynamic>? collection = (await userCollection.get()).data();

      if (collection == null) {
        return null;
      }
      List<dynamic> favourites = collection['favourites'];
      favourites.removeAt(event.index);

      await userCollection.update({'favourites': favourites});
      emit(ContentRemoveFavSongSuccess());
    } catch (e) {
      emit(ContentRemoveFavSongError());
    }
  }

  Future<void> getFavouritesList(event, emit) async {
    emit(ContentGetFavMusicLoading());
    try {
      DocumentReference<Map<String, dynamic>> userCollection =
          getUserCollection();

      Map<String, dynamic>? collection = (await userCollection.get()).data();

      if (collection == null) {
        return null;
      }
      List<dynamic> favourites = collection['favourites'];
      if (favourites.isEmpty) {
        emit(ContentGetFavMusicIsEmpty());
      } else {
        emit(ContentGetFavMusicSuccess(favourites: favourites));
      }
    } catch (e) {
      emit(ContentGetFavMusicError());
    }
  }

  DocumentReference<Map<String, dynamic>> getUserCollection() {
    final userCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    return userCollection;
  }
}
