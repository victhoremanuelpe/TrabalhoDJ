int[][] board = new int[3][3];
boolean gameStarted = false;
boolean playingWithComputer = false;
boolean playerX = true;
boolean gameOver = false;
int winner = 0;
String gameMessage = "Escolha uma opção";
boolean canGoBackToMenu = false;

int boardSize = 400;
int cellSize = boardSize / 3;

void setup() {
  size(600, 600);
  textAlign(CENTER, CENTER);
  textSize(32);
  drawMenu();
}

void draw() {
  background(235);
  if (!gameStarted) {
    drawMenu();
  } else {
    drawBoard();
    displayMessage();
    if (gameOver) {
      drawBackButton();
    }
  }
}

void drawMenu() {
  background(235);
  fill(0);
  textSize(50);
  text("Jogo da Velha", width / 2, height / 4 - 30);
  fill(70, 130, 180);
  noStroke();
  rect(width / 4, height / 2 - 40, width / 2, 50, 20);
  rect(width / 4, height / 2 + 50, width / 2, 50, 20);
  fill(255);
  textSize(20);
  text("Jogar contra o computador", width / 2, height / 2 - 15);
  text("Jogar contra outro jogador", width / 2, height / 2 + 73);
}

void drawBoard() {
  int startX = (width - boardSize) / 2;
  int startY = (height - boardSize) / 2;

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      float x = startX + i * cellSize;
      float y = startY + j * cellSize;
      if (board[i][j] == 1) {
        fill(255, 0, 0);
        textSize(64);
        text("X", x + cellSize / 2, y + cellSize / 2);
      } else if (board[i][j] == -1) {
        fill(0, 0, 255);
        textSize(64);
        text("O", x + cellSize / 2, y + cellSize / 2);
      }
      stroke(0);
      noFill();
      rect(x, y, cellSize, cellSize);
    }
  }
}

void displayMessage() {
  fill(0);
  textSize(24);
  text(gameMessage, width / 2, height - 550);
}

void drawBackButton() {
  fill(34, 139, 34);
  noStroke();
  rect(width / 4, height - 90, width / 2, 40, 20);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Voltar ao Menu", width / 2, height - 70);
}

void mousePressed() {
  if (!gameStarted) {
    if (mouseX > width / 4 && mouseX < width / 4 + width / 2 &&
        mouseY > height / 2 - 30 && mouseY < height / 2 + 10) {
      playingWithComputer = true;
      gameStarted = true;
      gameMessage = "Você jogará contra o computador. X começa!";
      initializeBoard();
    }
    if (mouseX > width / 4 && mouseX < width / 4 + width / 2 &&
        mouseY > height / 2 + 40 && mouseY < height / 2 + 80) {
      playingWithComputer = false;
      gameStarted = true;
      gameMessage = "Você escolheu jogar contra outro jogador. X começa!";
      initializeBoard();
    }
  } else if (gameOver && canGoBackToMenu) {
    if (mouseX > width / 4 && mouseX < width / 4 + width / 2 &&
        mouseY > height - 90 && mouseY < height - 50) {
      gameStarted = false;
      gameOver = false;
      canGoBackToMenu = false;
      gameMessage = "Escolha uma opção";
      initializeBoard();
      redraw();
    }
  } else {
    int i = floor((mouseX - (width - boardSize) / 2) / cellSize);
    int j = floor((mouseY - (height - boardSize) / 2) / cellSize);

    if (board[i][j] == 0) {
      board[i][j] = playerX ? 1 : -1;
      playerX = !playerX;
      checkWinner();
      if (!gameOver && playingWithComputer && !playerX) {
        computerMove();
        checkWinner();
        playerX = !playerX;
      }
      redraw();
    }
  }
}

void checkWinner() {
  for (int i = 0; i < 3; i++) {
    if (abs(board[i][0] + board[i][1] + board[i][2]) == 3) {
      gameOver = true;
      winner = board[i][0];
    }
    if (abs(board[0][i] + board[1][i] + board[2][i]) == 3) {
      gameOver = true;
      winner = board[0][i];
    }
  }

  if (abs(board[0][0] + board[1][1] + board[2][2]) == 3) {
    gameOver = true;
    winner = board[0][0];
  }
  if (abs(board[0][2] + board[1][1] + board[2][0]) == 3) {
    gameOver = true;
    winner = board[0][2];
  }

  boolean full = true;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == 0) {
        full = false;
      }
    }
  }
  if (full && !gameOver) {
    gameOver = true;
    winner = 2;
  }

  if (gameOver) {
    gameMessage = winner == 1 ? "Jogador X venceu!" : (winner == -1 ? "Jogador O venceu!" : "Empate!");
    canGoBackToMenu = true;
    redraw();
  }
}

void initializeBoard() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      board[i][j] = 0;
    }
  }
  playerX = true;
  gameOver = false;
  winner = 0;
  canGoBackToMenu = false;
  redraw();
}

void computerMove() {
  int i, j;
  do {
    i = int(random(3));
    j = int(random(3));
  } while (board[i][j] != 0);
  board[i][j] = -1;
}
