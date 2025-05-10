import 'package:fetch_api_bloc/models/game.dart';
import 'package:fetch_api_bloc/sources/game_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'live_game_event.dart';
part 'live_game_state.dart';

class LiveGameBloc extends Bloc<LiveGameEvent, LiveGameState> {
  LiveGameBloc() : super(LiveGameInitial()) {
    on<OnFecthLiveGame>((event, emit) async {
      emit(LiveGameLoading());
      List<Game>? result = await GameSource.getLiveGames();
      if (result == null) {
        emit(LiveGameFailure("Failed to fetch live games"));
      } else {
        emit(LiveGameLoaded(result));
      }
    });
  }
}
