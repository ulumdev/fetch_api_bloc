import 'package:extended_image/extended_image.dart';
import 'package:fetch_api_bloc/bloc/live_game_bloc.dart';
import 'package:fetch_api_bloc/cubit/genre_cubit.dart';
import 'package:fetch_api_bloc/models/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveGamePage extends StatefulWidget {
  const LiveGamePage({super.key});

  @override
  State<LiveGamePage> createState() => _LiveGamePageState();
}

class _LiveGamePageState extends State<LiveGamePage> {
  List<String> genres = ['Shooter', 'MMOARPG', 'ARPG', 'Strategy', 'Fighting'];

  @override
  void initState() {
    context.read<LiveGameBloc>().add(OnFecthLiveGame());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Games Page')),
      body: Column(
        children: [
          BlocBuilder<GenreCubit, String>(
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Row(
                    children:
                        genres
                            .map(
                              (genre) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<GenreCubit>().onSelectedGenre(
                                      genre,
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black87),
                                      borderRadius: BorderRadius.circular(4),
                                      color:
                                          state == genre
                                              ? Theme.of(context).primaryColor
                                              : Colors.white,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      genre,
                                      style: TextStyle(
                                        color:
                                            state == genre
                                                ? Colors.white
                                                : Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<LiveGameBloc, LiveGameState>(
              builder: (context, state) {
                if (state is LiveGameLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LiveGameFailure) {
                  return Center(child: Text(state.message));
                } else if (state is LiveGameLoaded) {
                  List<Game> games = state.games;
                  if (games.isEmpty) {
                    return const Center(child: Text('No live games available'));
                  }
                  return BlocBuilder<GenreCubit, String>(
                    builder: (context, genreState) {
                      List<Game> list =
                          games
                              .where((game) => game.genre == genreState)
                              .toList();
                      return GridView.builder(
                        itemCount: list.length,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(2),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemBuilder: (context, index) {
                          Game game = list[index];
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: ExtendedImage.network(
                                  game.thumbnail!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black,
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment(0, -0.3),
                                    ),
                                  ),
                                  alignment: Alignment.bottomLeft,
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    game.title ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
