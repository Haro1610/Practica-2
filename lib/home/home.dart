import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practica_2/content/bloc/content_bloc.dart';
import 'package:practica_2/content/favorites/favorites.dart';
import 'package:practica_2/content/song/song_page.dart';
import 'package:practica_2/home/bloc/record_bloc.dart';
import 'package:practica_2/login/login.dart';
import '../auth/bloc/auth_bloc.dart';
import '../content/favorites/favorites.dart';
import '../content/song/song_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _listen = "Presiona para iniciar la grabacion";
  bool _animacion = false;
  var _iconColor = Colors.green;
  bool pressed = false;
  var _song, _artist, _album, _date, _apple, _spotify, _cover, _link;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: BlocConsumer<RecordBloc, RecordState>(
          listener: (context, state) {
            if (state is RecordSuccessState) {
              _song = state.song;
              _artist = state.artist;
              _album = state.album;
              _date = state.releaseDate;
              _apple = state.appleMussic;
              _spotify = state.spotify;
              _cover = state.albumCover;
              _link = state.listenLink;
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SongPage(song: {
                  "songName": _song,
                  "artistName": _artist,
                  "albumName": _album,
                  "releaseDate": _date,
                  "appleLink": _apple,
                  "spotifyLink": _spotify,
                  "albumCover": _cover,
                  "listenLink": _link,
                }),
              ));
              _animacion = false;
              _listen = "";
              _iconColor = Colors.green;
            } else if (state is RecordErrorState) {
              print("$state");
              _animacion = false;
              _listen = "Preciona para iniciar la grabacion";
              _iconColor = Colors.green;
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text("Cancion desconocida, intenta de nuevo"),
                  backgroundColor: Colors.orangeAccent,
                ));
            } else if (state is RecordFinishedState) {
              _animacion = true;
              _iconColor = Colors.purple;
              _listen = "Detectando cancion";
              print("$state");
            } else if (state is RecordListeningState) {
              print("$state");
              _animacion = true;
              _iconColor = Colors.purple;
              _listen = "Escuchando...";
            } else if (state is RecordInitial) {
              print("$state");
            } else if (state is RecordMissingValuesState) {
              print("$state");
              _animacion = false;
              _listen = "Presione para escuchar";
              _iconColor = Colors.green;
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text("No se encontró la canción."),
                  backgroundColor: Colors.red,
                ));
            }

            // TODO: implement listener
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Toque para escuchar",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                AvatarGlow(
                  animate: _animacion,
                  glowColor: Colors.deepOrangeAccent,
                  endRadius: 200.0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {});
                      pressed = true;
                      BlocProvider.of<RecordBloc>(context)
                          .add(RecordUpdateEvent());
                    },
                    child: Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          radius: 100.0,
                          child: Image.asset(
                            'assets/music_logo.png',
                            height: 200,
                          )),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Favorites()));
                          BlocProvider.of<ContentBloc>(context)
                              .add(GetFavouriteMusicEvent());
                        },
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.power_settings_new),
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(SingOutEvent());
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
