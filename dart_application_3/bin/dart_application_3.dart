import 'dart:io';
import 'dart:math';

void main() {
  bool playAgain = true;

  while (playAgain) {
    print("Добро пожаловать в игру Крестики-нолики!");

    int gameMode = chooseGameMode();
    int fieldSize = getFieldSize();
    List<String> gameBoard = List.filled(fieldSize * fieldSize, " ");

    String currentPlayer = chooseRandomPlayer();
     if(gameMode == 2) {
       print("Вы играете против робота");
    } else {
      print("Первым ходит игрок: $currentPlayer");
     }

    bool gameFinished = false;

    while (!gameFinished) {
      printGameBoard(gameBoard, fieldSize);
      print("Ход игрока $currentPlayer.");
        if (gameMode == 2 && currentPlayer == "O"){
          int moveIndex = getRobotMove(gameBoard, fieldSize);
          gameBoard[moveIndex] = currentPlayer;
        }else{
        int moveIndex = getPlayerMove(gameBoard, fieldSize);
        gameBoard[moveIndex] = currentPlayer;
      }
      if (checkWinner(gameBoard, fieldSize, currentPlayer)) {
        printGameBoard(gameBoard, fieldSize);
        if(gameMode == 2 && currentPlayer == 'O') {
            print("Победил робот!");
          } else {
              print("Игрок $currentPlayer победил!");
          }
        gameFinished = true;
      } else if (isBoardFull(gameBoard)) {
        printGameBoard(gameBoard, fieldSize);
        print("Ничья!");
        gameFinished = true;
      } else {
          if(gameMode == 1) {
           currentPlayer = currentPlayer == "X" ? "O" : "X";
         } else {
           currentPlayer = currentPlayer == "X" ? "O" : "X";
         }
      }
    }
    playAgain = askPlayAgain();
  }
  print("Спасибо за игру!");
}

String chooseRandomPlayer() {
  Random random = Random();
  return random.nextBool() ? "X" : "O";
}

int chooseGameMode() {
    while(true) {
      stdout.write("Выберите режим игры:\n1. Игрок против игрока\n2. Игрок против робота\n");
      String? input = stdin.readLineSync();
      if(input == null) continue;
       try{
         int mode = int.parse(input);
         if(mode == 1 || mode == 2) {
           return mode;
         } else {
            print("Некорректный режим, выберите 1 или 2");
         }
       } catch (e) {
          print("Некорректный ввод, введите целое число");
       }
    }
}

int getFieldSize() {
  int size;
  while (true) {
    stdout.write("Введите размер игрового поля (целое число больше 2): ");
    String? input = stdin.readLineSync();
    if (input == null) continue;
    try {
      size = int.parse(input);
      if (size > 2) return size;
      print("Пожалуйста, введите целое число больше 2.");
    } catch (e) {
      print("Некорректный ввод. Пожалуйста, введите целое число.");
    }
  }
}

void printGameBoard(List<String> board, int size) {
  for (int i = 0; i < board.length; i++) {
    stdout.write(" ${board[i]} ");
    if ((i + 1) % size == 0) {
      print("");
      if (i < board.length -1) {
        for(int j = 0; j < size; j++){
          stdout.write("----");
        }
        print("");
      }
    } else {
      stdout.write("|");
    }
  }
}

int getPlayerMove(List<String> board, int size) {
  int moveIndex;
  while (true) {
    stdout.write("Введите номер ячейки от 1 до ${board.length}: ");
    String? input = stdin.readLineSync();
    if(input == null) continue;
    try {
      int move = int.parse(input);
      if (move >= 1 && move <= board.length) {
        moveIndex = move - 1;
        if (board[moveIndex] == " ") {
          return moveIndex;
        } else {
          print("Эта ячейка уже занята. Попробуйте еще раз.");
        }
      } else {
        print("Номер ячейки должен быть в пределах от 1 до ${board.length}.");
      }
    } catch (e) {
      print("Некорректный ввод. Пожалуйста, введите целое число.");
    }
  }
}

int getRobotMove(List<String> board, int size) {
    for(int i=0; i < board.length; i++) {
      if(board[i] == " ") {
        List<String> tempBoard = List.from(board);
        tempBoard[i] = "O";
        if(checkWinner(tempBoard, size, "O")) {
          return i;
        }
      }
    }
    for(int i=0; i < board.length; i++) {
      if(board[i] == " ") {
        List<String> tempBoard = List.from(board);
        tempBoard[i] = "X";
        if(checkWinner(tempBoard, size, "X")) {
          return i;
        }
      }
    }
    List<int> emptyCells = [];
    for (int i = 0; i < board.length; i++) {
        if (board[i] == " ") {
            emptyCells.add(i);
        }
    }
    if (emptyCells.isNotEmpty) {
        Random random = Random();
        return emptyCells[random.nextInt(emptyCells.length)];
    }
    return -1;
}

bool checkWinner(List<String> board, int size, String player) {
  for (int i = 0; i < board.length; i += size) {
    bool won = true;
    for(int j = 0; j < size; j++) {
      if(board[i+j] != player) {
        won = false;
        break;
      }
    }
    if(won) return true;
  }
  for(int j = 0; j < size; j++) {
    bool won = true;
    for(int i = 0; i < board.length; i+=size) {
      if(board[i+j] != player) {
        won = false;
        break;
      }
    }
    if(won) return true;
  }
  bool wonDiagonal1 = true;
  for(int i = 0; i < board.length; i += size + 1) {
    if(board[i] != player){
      wonDiagonal1 = false;
      break;
    }
  }
  if (wonDiagonal1) return true;
  bool wonDiagonal2 = true;
  for (int i = size - 1; i < board.length -1; i += size - 1) {
    if(board[i] != player) {
      wonDiagonal2 = false;
      break;
    }
  }
  if (wonDiagonal2) return true;
  return false;
}

bool isBoardFull(List<String> board) {
  return board.every((cell) => cell != " ");
}

bool askPlayAgain() {
  while(true){
    stdout.write("Хотите сыграть еще раз? (y/n): ");
    String? input = stdin.readLineSync();
    if(input == null) continue;
    if(input.toLowerCase() == "y") return true;
    if(input.toLowerCase() == "n") return false;

    print("Некорректный ввод. Пожалуйста, введите 'y' или 'n'.");
  }
}



