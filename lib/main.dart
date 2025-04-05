import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: PocGame(),
      overlayBuilderMap: {
        "spawnMenu": (context, PocGame game) {
          return Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              children: [
                Row(
                  children: [
                    FloatingActionButton(onPressed: game.spawnRiveComponents, child: Icon(Icons.add)),
                    const SizedBox(width: 8),
                    FloatingActionButton(onPressed: game.despawnRiveComponents, child: Icon(Icons.remove)),
                  ],
                ),
              ],
            ),
          );
        },
        "fpsCounter": (contexts, PocGame game) {
          return StreamBuilder<double>(
            stream: game.fpsStream.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SafeArea(child: Text("FPS: ${snapshot.data!.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white))),
                );
              }
              return const SizedBox();
            },
          );
        },
        "objectsCounter": (context, PocGame game) {
          return StreamBuilder<int>(
            stream: game.objectCountStream.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Positioned(
                  top: 8,
                  right: 8,
                  child: SafeArea(child: Text("Objects: ${snapshot.data?.toString() ?? 0}", style: const TextStyle(color: Colors.white))),
                );
              }
              return const SizedBox();
            },
          );
        },
      },
    );
  }
}
