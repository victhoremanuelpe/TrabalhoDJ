import java.util.HashSet;

String[][] categorias = {
  {"Frutas", "Banana", "Maca", "Laranja", "Morango", "Uva", "Abacaxi", "Kiwi", "Melancia", "Cabeluda"},
  {"Animais", "Cachorro", "Gato", "Elefante", "Tigre", "Leao", "Girafa", "Zebra", "Rato", "Macaco"},
  {"Cidades", "Sao Paulo", "Rio de Janeiro", "Salvador", "Recife", "Brasilia", "Porto Alegre", "Curitiba", "Fortaleza", "Manaus"},
  {"Veiculos", "Carro", "Moto", "Bicicleta", "Onibus", "Aviao", "Navio", "Trem", "Helicoptero", "Caminhao"},
  {"Esportes", "Futebol", "Basquete", "Volei", "Natacao", "Handebol", "Golfe", "Boxe", "Rugby", "Xadrez", "Corrida"},
  {"Comidas", "Pizza", "Hamburguer", "Macarrao", "Sushi", "Feijoada", "Lasanha", "Salada", "Churrasco", "Arroz", "Bife"},
  {"Paises", "Brasil", "Argentina", "Franca", "Italia", "Espanha", "Alemanha", "Estados Unidos", "Japao", "Canada", "Australia"}
};

String categoriaEscolhida;
String palavraEscolhida;
String palavraOculta;
String dica;
int tentativas = 6;
ArrayList<Character> letrasErradas;
HashSet<Character> letrasTentadas;
boolean jogoAtivo;
boolean jogadorVenceu;
int tempoReinicio = 0;

void setup() {
  size(800, 600);
  frameRate(60);
  iniciarJogo();
}

void draw() {
  background(245);
  
  textSize(24);
  fill(50);
  textAlign(LEFT);
  text(dica, 30, 50);
  
  mostrarPalavraOculta();
  
  textSize(20);
  fill(200, 0, 0);
  text("Tentativas restantes: " + tentativas, 30, 120);
  
  fill(0);
  text("Letras erradas: " + letrasErradas.toString().toUpperCase(), 30, 150);
  
  desenharForca();
  
  if (!jogoAtivo) {
    fill(0);
    textSize(28);
    textAlign(CENTER, CENTER);
    
    if (jogadorVenceu) {
      fill(0, 200, 0);
      text("Você venceu!", width / 2, height / 2 + 200);
      if (millis() - tempoReinicio > 3000) {
        iniciarJogo();
      }
    } else {
      fill(200, 0, 0);
      text("Fim de Jogo! A palavra era: " + palavraEscolhida, width / 2, height / 2 + 200);
      desenharBotaoReiniciar();
    }
  }
}

void keyPressed() {
  if (jogoAtivo && (key >= 'a' && key <= 'z' || key >= 'A' && key <= 'Z')) {
    char letra = Character.toLowerCase(key);
    
    if (letrasTentadas.contains(letra)) {
      return;
    }
    
    letrasTentadas.add(letra);
    
    if (palavraEscolhida.toLowerCase().contains(String.valueOf(letra))) {
      atualizarPalavraOculta(letra);
      if (palavraOculta.equalsIgnoreCase(palavraEscolhida)) {
        jogoAtivo = false;
        jogadorVenceu = true;
        tempoReinicio = millis();
      }
    } else {
      letrasErradas.add(Character.toUpperCase(letra));
      tentativas--;
      if (tentativas <= 0) {
        jogoAtivo = false;
        jogadorVenceu = false;
      }
    }
  }
}

void mousePressed() {
  if (!jogoAtivo && !jogadorVenceu && 
      mouseX > width - 200 && mouseX < width - 50 && 
      mouseY > height - 60 && mouseY < height - 20) {
    iniciarJogo();
  }
}

void iniciarJogo() {
  int categoriaIndex = int(random(categorias.length));
  String[] categoria = categorias[categoriaIndex];
  categoriaEscolhida = categoria[0];
  dica = "Categoria: " + categoriaEscolhida;
  
  int palavraIndex = int(random(1, categoria.length));
  palavraEscolhida = categoria[palavraIndex];
  palavraOculta = "";
  
  for (int i = 0; i < palavraEscolhida.length(); i++) {
    if (palavraEscolhida.charAt(i) == ' ') {
      palavraOculta += " ";
    } else {
      palavraOculta += "_";
    }
  }
  
  letrasErradas = new ArrayList<Character>();
  letrasTentadas = new HashSet<Character>();
  tentativas = 6;
  jogoAtivo = true;
  jogadorVenceu = false;
}

void mostrarPalavraOculta() {
  textSize(48);
  fill(0);
  float x = width / 2 - (textWidth(palavraOculta.replace(" ", "_")) / 2);
  
  for (int i = 0; i < palavraOculta.length(); i++) {
    char c = palavraOculta.charAt(i);
    if (c == ' ') {
      // Não mostra nada para espaços
    } else if (c == '_') {
      text("_", x + i * 30, height / 2 + 30);
    } else {
      text(c, x + i * 30, height / 2 + 30);
    }
  }
}

void atualizarPalavraOculta(char letra) {
  StringBuilder sb = new StringBuilder(palavraOculta);
  for (int i = 0; i < palavraEscolhida.length(); i++) {
    if (Character.toLowerCase(palavraEscolhida.charAt(i)) == letra) {
      sb.setCharAt(i, palavraEscolhida.charAt(i));
    }
  }
  palavraOculta = sb.toString();
}

void desenharForca() {
  float baseX = width / 9;
  float baseY = height / 1.7;
  float largura = 8;
  
  stroke(0);
  strokeWeight(largura);
  line(baseX, baseY + 200, baseX, baseY - 120);
  line(baseX, baseY - 120, baseX + 80, baseY - 120);
  line(baseX + 80, baseY - 120, baseX + 80, baseY - 40);
  
  if (tentativas <= 5) ellipse(baseX + 80, baseY - 40, 30, 30);
  
  if (tentativas <= 4) line(baseX + 80, baseY - 20, baseX + 80, baseY + 40);
  
  if (tentativas <= 3) line(baseX + 80, baseY - 15, baseX + 60, baseY + 20);
  if (tentativas <= 2) line(baseX + 80, baseY - 15, baseX + 100, baseY + 20);
  
  if (tentativas <= 1) line(baseX + 80, baseY + 40, baseX + 60, baseY + 80);
  if (tentativas <= 0) line(baseX + 80, baseY + 40, baseX + 100, baseY + 80);
}

void desenharBotaoReiniciar() {
  fill(255, 120, 120);
  noStroke();
  rect(width - 200, height - 60, 150, 40, 40);
  
  fill(255);
  textSize(18);
  textAlign(CENTER, CENTER);
  text("Reiniciar Jogo", width - 125, height - 40);
}
