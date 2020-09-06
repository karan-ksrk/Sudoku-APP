var Board = [
  [7, 8, 0, 4, 0, 0, 1, 2, 0],
  [6, 0, 0, 0, 7, 5, 0, 0, 9],
  [0, 0, 0, 6, 0, 1, 0, 7, 8],
  [0, 0, 7, 0, 4, 0, 2, 6, 0],
  [0, 0, 1, 0, 5, 0, 9, 3, 0],
  [9, 0, 4, 0, 6, 0, 0, 0, 5],
  [0, 7, 0, 3, 0, 0, 0, 1, 2],
  [1, 2, 0, 0, 0, 7, 4, 0, 0],
  [0, 4, 9, 2, 0, 6, 0, 0, 7]
];

void main() {
  //display(Board);
  solve(Board);
  print('======================');
  display(Board);
  print('======================');
}

void display(var Board) {
  for (int i = 0; i < 9; i++) {
    if (i % 3 == 0 && i != 0) print("- - - - - - - - - - -");
    print(
        "${Board[i][0]} ${Board[i][1]} ${Board[i][2]} | ${Board[i][3]} ${Board[i][4]} ${Board[i][5]} | ${Board[i][6]} ${Board[i][7]} ${Board[i][8]} ");
  }
}

List<int> find_empty(var Board) {
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      if (Board[i][j] == 0) return [i, j];
    }
  }
  return [-1];
}

bool isValid(var Board, int num, var pos) {
  for (int i = 0; i < 9; i++) {
    // Check row
    if (Board[pos[0]][i] == num && pos[1] != i) return false;
  }
  // Check row
  for (int i = 0; i < 9; i++) {
    if (Board[i][pos[1]] == num && pos[0] != i) {
      return false;
    }
  }

  // Check box
  int box_c = pos[1] ~/ 3;
  int box_r = pos[0] ~/ 3;

  for (int i = box_r * 3; i < box_r * 3 + 3; i++) {
    for (int j = box_c * 3; j < box_c * 3 + 3; j++) {
      if (Board[i][j] == num && pos != [i, j]) return false;
    }
    return true;
  }
}

bool solve(var Board) {
  int row, col;
  var find = find_empty(Board);
  if (find[0] == -1) {
    return true;
  } else {
    row = find[0];
    col = find[1];
  }
  for (int i = 1; i < 10; i++) {
    if (isValid(Board, i, [row, col])) {
      Board[row][col] = i;
      if (solve(Board)) {
        return true;
      }
      Board[row][col] = 0;
    }
  }

  return false;
}
