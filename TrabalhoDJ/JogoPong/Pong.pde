//Variáveis para o posicionamento da bola 
int ballX, ballY; 
int ballSize = 10; 
int ballSpeedX = 3;  // Velocidade inicial
int ballSpeedY = 3;  // Velocidade inicial
float difficultMultiplier = 1.0;  // Multiplicador de dificuldade

// Controle de tempo para aumentar a dificuldade
int lastDifficultyIncrease = 0;
int difficultyIncreaseInterval = 10000;  // A cada 10 segundos
float difficultyIncreaseAmount = 0.1;    // Aumenta 10% da velocidade cada vez
float maxDifficultyMultiplier = 3.0;     // Limite máximo do multiplicador (3x a velocidade inicial)

//Variáveis para o posicionamento das palhetas do jogador 
int playerPaddleX, playerPaddleY; 
int playerWidth = 10; 
int playerInitialHeight = 70;  // Altura inicial da paleta do jogador
int playerHeight = playerInitialHeight;  // Altura atual da paleta
int playerSpeedY = 0; 
int minPlayerHeight = 35;  // Altura mínima da paleta do jogador

//Variáveis para o posicionamento das palhetas do adversário 
int cpuPaddleX, cpuPaddleY; 
int cpuWidth = 10; 
int cpuInitialHeight = 70;  // Altura inicial da paleta do CPU
int cpuHeight = cpuInitialHeight;  // Altura atual da paleta
int cpuSpeedY = 0; 
int minCpuHeight = 35;  // Altura mínima da paleta do CPU

//Variáveis para marcar a pontuação 
int scorePlayer = 0;
int scoreCPU = 0;
int winningScore = 10;  // Pontuação máxima para vencer
boolean gameOver = false;
String winner = "";

// Variáveis para o menu e modo de jogo
boolean gameStarted = false;
boolean playerVsCPU = true;  // true = player vs CPU, false = player vs player
int player2SpeedY = 0;  // Velocidade da segunda paleta no modo multiplayer

//Função de inicialização 
void setup() 
{ 
  //Determinar o tamanho e a cor de fundo da tela 
  size(640, 360); 
  background(0); 

  //Atribui posição inicial da bola 
  ballX = width / 2; 
  ballY = height / 2; 

  //Atribui posição inicial da palheta do jogador 
  playerPaddleX = 10; 
  playerPaddleY = height / 2 - playerHeight / 2; 

  //Atribuir posição inicial da palheta do adversário 
  cpuPaddleX = width - 20; 
  cpuPaddleY = height/2 - cpuHeight / 2; 

  //Determina o tamanho da fonte do texto 
  textSize(32); 
  
  // Inicializa o tempo para o sistema de dificuldade
  lastDifficultyIncrease = millis();
} 

//Função de repetição 
void draw() 
{ 
  //Atualiza a cor de fundo toda vez que a tela for desenhada 
  background(0); 
  
  // Verifica se o jogo começou
  if (!gameStarted) {
    displayMenu();
    return;  // Sai da função draw se estiver no menu
  }

  // Verifica se o jogo acabou
  if (gameOver) {
    displayGameOver();
    return; // Sai da função draw se o jogo tiver acabado
  }

  // Atualiza o sistema de dificuldade (somente no modo CPU)
  if (playerVsCPU) {
    updateDifficulty();
  }

  //Chamadas de função para execução do jogo 
  score(); 
  ballMovement(); 
  
  if (playerVsCPU) {
    cpuPaddle();  // IA controla a raquete direita
  } else {
    player2Paddle();  // Jogador 2 controla a raquete direita
  }
  
  playerPaddle(); 
} 

// Função para exibir o menu de seleção
void displayMenu() {
  background(0);
  textAlign(CENTER);
  fill(255);
  
  text("PONG", width/2, height/2 - 80);
  
  // Destaca a opção selecionada
  if (playerVsCPU) {
    fill(255, 255, 0);  // Amarelo para a opção selecionada
    text("1 JOGADOR", width/2, height/2);
    fill(255);  // Branco para opção não selecionada
    text("2 JOGADORES", width/2, height/2 + 50);
  } else {
    fill(255);  // Branco para opção não selecionada
    text("1 JOGADOR", width/2, height/2);
    fill(255, 255, 0);  // Amarelo para a opção selecionada
    text("2 JOGADORES", width/2, height/2 + 50);
  }
  
  fill(255);
  textSize(20);
  text("Use as teclas CIMA/BAIXO para selecionar", width/2, height/2 + 100);
  text("Pressione ENTER para começar", width/2, height/2 + 130);
  
  // Restaura o tamanho do texto e alinhamento
  textSize(32);
  textAlign(LEFT);
}

// Função para mostrar a tela de fim de jogo
void displayGameOver() {
  background(0);
  textAlign(CENTER);
  fill(255);
  
  text("FIM DE JOGO", width/2, height/2 - 50);
  text(winner + " VENCEU!", width/2, height/2);
  textSize(20);
  text("Pontuação final: " + scorePlayer + " - " + scoreCPU, width/2, height/2 + 50);
  text("Pressione ESPAÇO para jogar novamente", width/2, height/2 + 80);
  text("Pressione M para voltar ao menu", width/2, height/2 + 110);
  
  // Restaura o tamanho do texto
  textSize(32);
  textAlign(LEFT);
}

// Função para atualizar a dificuldade com base no tempo de jogo
void updateDifficulty() {
  // Verifica se é hora de aumentar a dificuldade
  if (millis() - lastDifficultyIncrease > difficultyIncreaseInterval) {
    // Aumenta o multiplicador de dificuldade
    if (difficultMultiplier < maxDifficultyMultiplier) {
      difficultMultiplier += difficultyIncreaseAmount;
      
      // Limita o multiplicador ao máximo definido
      if (difficultMultiplier > maxDifficultyMultiplier) {
        difficultMultiplier = maxDifficultyMultiplier;
      }
      
      // Reduz o tamanho da paleta do jogador
      int heightReduction = 3;  // Redução de 3 pixels por nível
      playerHeight = playerHeight - heightReduction;
      
      // Limita a altura mínima da paleta do jogador
      if (playerHeight < minPlayerHeight) {
        playerHeight = minPlayerHeight;
      }
      
      // Reduz o tamanho da paleta do CPU também (para equilibrar)
      int cpuHeightReduction = 6;  // Redução maior para o CPU, já que começa maior
      cpuHeight = cpuHeight - cpuHeightReduction;
      
      // Limita a altura mínima da paleta do CPU
      if (cpuHeight < minCpuHeight) {
        cpuHeight = minCpuHeight;
      }
      
      // Ajusta a posição Y para manter a paleta centralizada após a redução
      playerPaddleY = playerPaddleY + (heightReduction / 2);
      cpuPaddleY = cpuPaddleY + (cpuHeightReduction / 2);
    }
    
    // Atualiza o tempo do último aumento
    lastDifficultyIncrease = millis();
  }
}

//Função da movimentação da bola 
void ballMovement() { 
  // Calcula a velocidade atual com base na dificuldade (só aplica no modo CPU)
  float currentSpeedX = playerVsCPU ? ballSpeedX * difficultMultiplier : ballSpeedX;
  float currentSpeedY = playerVsCPU ? ballSpeedY * difficultMultiplier : ballSpeedY;
  
  //Atualização da posição da bola com a velocidade ajustada
  ballX = ballX + int(currentSpeedX);
  ballY = ballY + int(currentSpeedY);

  //Verificação da colisão da bola com as extremidades laterais 
  if (ballX > width) { 
    ballX = width / 2; 
    ballY = height / 2; 
    ballSpeedX = ballSpeedX * -1; 
    scorePlayer += 1; 
    checkWin();
  } 
  if (ballX < 0) { 
    ballX = width / 2; 
    ballY = height / 2; 
    ballSpeedX = ballSpeedX * -1; 
    scoreCPU += 1; 
    checkWin();
  } 

  //Verificação da colisão da bola com as extremidades superior e inferior da tela 
  if (ballY > height) { 
    ballY = height - ballSize / 2; 
    ballSpeedY = ballSpeedY * -1; 
  } 
  if (ballY < 0) { 
    ballY = ballSize / 2; 
    ballSpeedY = ballSpeedY * -1; 
  } 
  
  //Verificação da colisão da bola com a palheta do jogador 
  if ((ballY + ballSize / 2 >= playerPaddleY && ballY - ballSize / 2 <= playerPaddleY + 
playerHeight) && 
    (ballX + ballSize / 2 >= playerPaddleX && ballX - ballSize / 2 <= playerPaddleX + 
playerWidth)) { 
    ballSpeedX = ballSpeedX * -1; 
    ballX = ballSize / 2 + playerPaddleX + playerWidth; 
  } 

  //Verificação da colisão da bola com a palheta do adversário 
  if ((ballY + ballSize / 2 >= cpuPaddleY && ballY - ballSize / 2 <= cpuPaddleY + 
cpuHeight) && 
    (ballX + ballSize / 2 >= cpuPaddleX && ballX - ballSize / 2 <= cpuPaddleX + 
cpuWidth)) { 
    ballSpeedX = ballSpeedX * -1; 
    ballX = cpuPaddleX - ballSize / 2; 
  } 
  
  noStroke(); 
  fill(255);  // Cor branca para a bola
  ellipse(ballX, ballY, ballSize, ballSize); 
} 

// Função para verificar se alguém venceu
void checkWin() {
  if (scorePlayer >= winningScore) {
    gameOver = true;
    winner = playerVsCPU ? "JOGADOR" : "JOGADOR 1";
  } else if (scoreCPU >= winningScore) {
    gameOver = true;
    winner = playerVsCPU ? "CPU" : "JOGADOR 2";
  }
}

//Função da palheta do adversário 
void cpuPaddle() { 
  //Atualizando a posição da palheta do adversário 
  cpuPaddleY = cpuPaddleY + cpuSpeedY; 

  //Criação do comportamento da palheta inimiga 
  if (ballX > width / 2) { 
    if (ballY - ballSize > cpuPaddleY + cpuHeight / 2) { 
      cpuSpeedY = 5; 
    } else if (ballY + ballSize < cpuPaddleY + cpuHeight / 2) { 
      cpuSpeedY = -5; 
    } else { 
      cpuSpeedY = 0; 
    } 
  } else { 
    cpuSpeedY = 0; 
  } 

  //Limitação dos movimentos da palheta dentro do espaço da tela 
  if (cpuPaddleY + cpuHeight > height) { 
    cpuPaddleY = height - cpuHeight; 
  } 
  if (cpuPaddleY < 0) { 
    cpuPaddleY = 0; 
  } 

  fill(255);  // Cor branca para a paleta
  rect(cpuPaddleX, cpuPaddleY, cpuWidth, cpuHeight); 
}

// Função da palheta do jogador 2 (para o modo multiplayer)
void player2Paddle() {
  // Atualizando a posição da palheta do jogador 2
  cpuPaddleY = cpuPaddleY + player2SpeedY;
  
  // Limitação dos movimentos da palheta dentro do espaço da tela
  if (cpuPaddleY + cpuHeight > height) {
    cpuPaddleY = height - cpuHeight;
  }
  if (cpuPaddleY < 0) {
    cpuPaddleY = 0;
  }
  
  fill(255);  // Cor branca para a paleta
  rect(cpuPaddleX, cpuPaddleY, cpuWidth, cpuHeight);
}

//Função da palheta do jogador 
void playerPaddle() { 
  //Atualizando a posição da palheta do jogador 
  playerPaddleY = playerPaddleY + playerSpeedY; 

  //Limitação dos movimentos da palheta dentro do espaço da tela 
  if (playerPaddleY + playerHeight > height) { 
    playerPaddleY = height - playerHeight; 
  } 
  if (playerPaddleY < 0) { 
    playerPaddleY = 0; 
  } 

  fill(255);  // Cor branca para a paleta
  rect(playerPaddleX, playerPaddleY, playerWidth, playerHeight); 
}

// Exibe o placar 
void score() { 
  fill(255);  // Cor branca para o texto
  
  // Ajusta o texto dependendo do modo de jogo
  if (playerVsCPU) {
    text("JOGADOR", 100, 50);
    text("CPU", 460, 50);
  } else {
    text("JOGADOR 1", 80, 50);
    text("JOGADOR 2", 380, 50);
  }
  
  text(scorePlayer, 160, 90);
  text(scoreCPU, 480, 90);
} 

//Verificação do pressionamento dos botões
void keyPressed() {
  // Controles menu
  if (!gameStarted) {
    if (keyCode == UP || keyCode == DOWN) {
      playerVsCPU = !playerVsCPU;  // Alterna entre os modos
    }
    if (keyCode == ENTER) {
      gameStarted = true;
      resetGame();
    }
    return;
  }
  
  // Controles durante o jogo
  if (key == 's' || key == 'S') { 
    playerSpeedY = 5; 
  } 
  if (key == 'w' || key == 'W') { 
    playerSpeedY = -5; 
  }
  
  // Controles do jogador 2 (somente no modo multiplayer)
  if (!playerVsCPU) {
    if (keyCode == DOWN) {
      player2SpeedY = 5;
    }
    if (keyCode == UP) {
      player2SpeedY = -5;
    }
  }
  
  // Reiniciar o jogo quando pressionar espaço na tela de fim de jogo
  if (key == ' ' && gameOver) {
    resetGame();
  }
  
  // Voltar ao menu quando pressionar M na tela de fim de jogo
  if ((key == 'm' || key == 'M') && gameOver) {
    gameStarted = false;
    gameOver = false;
  }
} 

// Função para reiniciar o jogo
void resetGame() {
  // Reinicia pontuações
  scorePlayer = 0;
  scoreCPU = 0;
  
  // Reinicia as alturas das paletas
  playerHeight = playerInitialHeight;
  cpuHeight = cpuInitialHeight;
  
  // Reinicia posições
  ballX = width / 2;
  ballY = height / 2;
  playerPaddleY = height / 2 - playerHeight / 2;
  cpuPaddleY = height / 2 - cpuHeight / 2;
  
  // Reinicia velocidades
  playerSpeedY = 0;
  cpuSpeedY = 0;
  player2SpeedY = 0;
  
  // Reinicia dificuldade
  difficultMultiplier = 1.0;
  
  // Reinicia o tempo para o sistema de dificuldade
  lastDifficultyIncrease = millis();
  
  // Reinicia o estado do jogo
  gameOver = false;
  winner = "";
}

//Verificação do soltar dos botões
void keyReleased() { 
  // Controles do jogador 1
  if (key == 's' || key == 'S' || key == 'w' || key == 'W') { 
    playerSpeedY = 0; 
  }
  
  // Controles do jogador 2 (somente no modo multiplayer)
  if (!playerVsCPU) {
    if (keyCode == DOWN || keyCode == UP) {
      player2SpeedY = 0;
    }
  }
}
