class Chess {
  void walkPawn() {
    print('Вы сделали ход пешкой');
  }

  void walkElephant() {
    print('Вы сделали ход слоном');
  }

  void walkHorse() {
    print('Вы сделали ход конем');
  }
}

abstract class ChessCommand {
  void execute();
}

class WalkPawn implements ChessCommand {
  Chess _chess;
  WalkPawn(this._chess);

  @override
  void execute() {
    _chess.walkPawn();
  }
}

class WalkHorse implements ChessCommand {
  Chess _chess;
  WalkHorse(this._chess);

  @override
  void execute() {
    _chess.walkHorse();
  }
}

class WalkElephant implements ChessCommand {
  Chess _chess;
  WalkElephant(this._chess);

  @override
  void execute() {
    _chess.walkElephant();
  }
}

class ChessExecutor {
  List<ChessCommand> chessOperations = [];

  void execute(ChessCommand chessCommand) {
    chessOperations.add(chessCommand);
    chessCommand.execute();
  }
}

void main() {
  Chess chess = Chess();

  ChessExecutor chessExecutor = ChessExecutor();

  chessExecutor.execute(WalkPawn(chess));
  chessExecutor.execute(WalkElephant(chess));
  chessExecutor.execute(WalkHorse(chess));

  print(chessExecutor.chessOperations);
}
