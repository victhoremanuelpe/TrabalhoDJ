PImage[] cartas;
PImage fundo, verso;
int[] tabuleiro;
boolean[] reveladas;
int cartaVirada1 = -1, cartaVirada2 = -1;
boolean podeVirar = true;
int paresEncontrados = 0;
int nivel = 1;
int tempoRestante;
int pontuacao = 0;
int colunas, linhas, totalCartas;
int cartaLargura, cartaAltura;
int margemX, margemY;
boolean transicaoNivel = false;

void setup() {
  size(880, 720); // Tamanho fixo da tela
  fundo = loadImage("fundo.png");
  fundo.resize(width, height);
  verso = loadImage("verso.png");
  iniciarJogo();
}

void iniciarJogo() {
  definirDificuldade();
  cartas = new PImage[totalCartas / 2];
  tabuleiro = new int[totalCartas];
  reveladas = new boolean[totalCartas];
  cartaLargura = (width - 100) / colunas;
  cartaAltura = (height - 200) / linhas;
  margemX = (width - (colunas * cartaLargura)) / 2;
  margemY = 50;

  for (int i = 0; i < totalCartas / 2; i++) {
    cartas[i] = loadImage("carta" + i + ".png");
  }

  int[] valores = new int[totalCartas];
  for (int i = 0; i < totalCartas / 2; i++) {
    valores[i * 2] = i;
    valores[i * 2 + 1] = i;
  }
  valores = embaralhar(valores);
  for (int i = 0; i < totalCartas; i++) {
    tabuleiro[i] = valores[i];
    reveladas[i] = false;
  }
  cartaVirada1 = -1;
  cartaVirada2 = -1;
  podeVirar = true;
  paresEncontrados = 0;
  tempoRestante = 60;
  transicaoNivel = false;
  loop();
}

void definirDificuldade() {
  if (nivel == 1) { colunas = 4; linhas = 4; }
  else if (nivel == 2) { colunas = 6; linhas = 4; }
  else { colunas = 8; linhas = 4; }
  totalCartas = colunas * linhas;
}

int[] embaralhar(int[] array) {
  for (int i = array.length - 1; i > 0; i--) {
    int j = (int) random(i + 1);
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
  return array;
}

void draw() {
  if (transicaoNivel) {
    telaTransicao();
    return;
  }
  
  background(fundo);
  fill(255);
  textSize(20);
  textAlign(CENTER);
  text("Nível: " + nivel + " | Tempo: " + tempoRestante + " | Pontuação: " + pontuacao, width / 2, height - 20);

  for (int i = 0; i < totalCartas; i++) {
    int x = (i % colunas) * cartaLargura + margemX;
    int y = (i / colunas) * cartaAltura + margemY;
    if (reveladas[i]) {
      image(cartas[tabuleiro[i]], x, y, cartaLargura, cartaAltura);
    } else {
      image(verso, x, y, cartaLargura, cartaAltura);
    }
  }
  if (frameCount % 60 == 0 && tempoRestante > 0) {
    tempoRestante--;
  }
  if (tempoRestante == 0) {
    nivel = 1;
    iniciarJogo();
  }
}

void mousePressed() {
  if (transicaoNivel) {
    if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100) {
      if (mouseY > height / 2 + 30 && mouseY < height / 2 + 80) {
        nivel++;
        if (nivel > 3) nivel = 1;
        iniciarJogo();
      } else if (mouseY > height / 2 + 90 && mouseY < height / 2 + 140) {
        iniciarJogo();
      }
    }
    return;
  }
  
  if (!podeVirar) return;
  if (cartaVirada1 != -1 && cartaVirada2 != -1) verificarPar();
  int coluna = (mouseX - margemX) / cartaLargura;
  int linha = (mouseY - margemY) / cartaAltura;
  int index = linha * colunas + coluna;
  if (index < totalCartas && !reveladas[index]) {
    if (cartaVirada1 == -1) cartaVirada1 = index;
    else if (cartaVirada2 == -1) cartaVirada2 = index;
    reveladas[index] = true;
  }
}

void verificarPar() {
  if (tabuleiro[cartaVirada1] != tabuleiro[cartaVirada2]) {
    reveladas[cartaVirada1] = false;
    reveladas[cartaVirada2] = false;
  } else {
    paresEncontrados++;
    pontuacao += 10 * nivel;
  }
  cartaVirada1 = -1;
  cartaVirada2 = -1;
  podeVirar = true;
  if (paresEncontrados == totalCartas / 2) {
    transicaoNivel = true;
  }
}

void telaTransicao() {
  background(0, 0, 0, 150);
  fill(255);
  textSize(30);
  textAlign(CENTER);
  text("Parabéns! Você passou para o nível " + (nivel + 1) + "!", width / 2, height / 2 - 20);
  fill(0, 200, 0);
  rect(width / 2 - 100, height / 2 + 30, 200, 50);
  fill(255);
  text("Avançar Nível", width / 2, height / 2 + 65);
  fill(200, 0, 0);
  rect(width / 2 - 100, height / 2 + 90, 200, 50);
  fill(255);
  text("Repetir Fase", width / 2, height / 2 + 125);
}
