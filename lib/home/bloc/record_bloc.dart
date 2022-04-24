import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:practica_2/env.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

part 'record_event.dart';
part 'record_state.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  RecordState get iniitialState => RecordInitial();

  RecordBloc() : super(RecordInitial()) {
    on<RecordEvent>(_identifySong);
    // TODO: implement event handler
  }

  FutureOr<void> _identifySong(RecordEvent event, Emitter emit) async {
    final path = await _getTemPath();
    print("File path error: $path");

    final pathFile = await record(path, emit);
    print("File path error: $pathFile");

    File file = File(pathFile!);

    print("File path bueno: $pathFile");
    String fileString = await fileConvert(file);
    print("Cosa random: $fileString");
    var json = await _response(fileString);
    print('$json');

    if (json == null || json["result"] == null) {
      emit(RecordErrorState());
    } else {
      try {
        final String song = json['result']['title'];
        final String artist = json['result']['artist'];
        final String album = json['result']['album'];
        final String date = json['result']['release_date'];
        final String apple = json['result']['apple_music']['url'];
        final String spotify =
            json['result']['spotify']['external_urls']['spotify'];
        final String image =
            json['result']['spotify']['album']['images'][0]['url'];
        final String link = json['result']['song_link'];

        emit(RecordSuccessState(
          song: song,
          artist: artist,
          album: album,
          releaseDate: date,
          appleMussic: apple,
          spotify: spotify,
          albumCover: image,
          listenLink: link,
        ));
      } catch (e) {
        print("Error: $e");
        emit(RecordMissingValuesState());
      }
    }
  }

  Future<String?> record(String path, Emitter<dynamic> emit) async {
    print("=======================Se empezo a ejecutar Recording");
    final Record _record = Record();
    print("permission = ${await _record.hasPermission()}");
    try {
      //get permission
      bool permission = await _record.hasPermission();

      if (permission) {
        emit(RecordListeningState());
        await _record.start(
            //path: '${path}/test.m4a',
            //encoder: AudioEncoder.AAC,
            //bitRate: 128000,
            //samplingRate: 44100,
            );
        await Future.delayed(Duration(seconds: 10));
        return await _record.stop();
      } else {
        emit(RecordErrorState());
        print("Permission denied");
      }
    } catch (e) {
      //print(e);
    }
    return null;
  }

  Future<String> _getTemPath() async {
    Directory tempDir = await getTemporaryDirectory();
    print("Temp dir path error: $tempDir");
    return tempDir.path;
  }

  Future<dynamic> _response(String file) async {
    print("$file");
    emit(RecordFinishedState());
    print("Will start sending");
    var url = Uri.parse('https://api.audd.io/');
    var response = await http.post(url, body: {
      'api_token': dotenv.env['API_KEY'],
      'return': 'apple_music,spotify',
      'audio': file,
      //'method': 'recognize',
    }
        //Uri.parse('https://api.audd.io/'),
        //headers: {'Content-Type': 'multipart/form-data'},
        // body: jsonEncode(
        //<String, dynamic>{
        // 'api_token': '5288e8cdda3b260a53338276baeb8d05',
        //'return': 'apple_music,spotify',
        //  'audio': file,
        //   'method': 'recognize',
        //},
        //),
        );
    if (response.statusCode == 200) {
      //print("Success");
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load json');
    }
  }
}

String fileConvert(File file) {
  Uint8List fileBytes = file.readAsBytesSync();
  //print("File bytes: $fileBytes");
  String base64String = base64Encode(fileBytes);
  //print("Base64 string: $base64String");
  return base64String;
}
