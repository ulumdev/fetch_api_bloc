import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:fetch_api_bloc/models/game.dart';
import 'package:http/http.dart' as http;

// import 'package:dio/dio.dart';

class GameSource {
  static Future<List<Game>?> getLiveGames() async {
    String url = 'https://www.freetogame.com/api/games';
    try {
      final response = await http.get(Uri.parse(url));
      DMethod.logResponse(response);
      if (response.statusCode == 200) {
        List list = jsonDecode(response.body);
        List<Game> games = list.map((game) => Game.fromJson(game)).toList();
        return games;
      } else {
        return null;
      }
    } catch (e) {
      DMethod.log(e.toString());
      return null;
    }
  }

  // static Future<List<Game>?> getLiveGamesUsingDio() async {
  //   final dio = Dio();
  //   String url = 'https://www.freetogame.com/api/games';
  //   try {
  //     final response = await dio.get(url);
  //     DMethod.logResponse(response.data);
  //     if (response.statusCode == 200) {
  //       List list = jsonDecode(response.data);
  //       List<Game> games = list.map((game) => Game.fromJson(game)).toList();
  //       return games;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     DMethod.log(e.toString());
  //     return null;
  //   }
  // }
}
