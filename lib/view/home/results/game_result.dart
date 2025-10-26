import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameResult extends StatelessWidget {
  static const String routeName = '/game_result';
  const GameResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, vm, _) {
      return Scaffold(
        body: Center(
          child: Text('Game Result Screen'),
        ),
      );
    });
  }
}
