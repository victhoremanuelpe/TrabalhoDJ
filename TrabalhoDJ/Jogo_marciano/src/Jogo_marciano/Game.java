package Jogo_marciano;

import java.util.Random;
import java.util.Scanner;

public class Game {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Random random = new Random();
        int melhorTentativa = Integer.MAX_VALUE;
        boolean jogarNovamente;

        // Introdução com a história
        System.out.println("=== O RESGATE DA PRINCESA CÓSMICA ===");
        System.out.println("Há muito tempo, no sistema estelar de Auroria, a paz reinava sob o comando da Princesa Zayra...");
        System.out.println("Até que um dia, o temível Lorde Xarkon atacou! Ele sequestrou a princesa e a escondeu em uma de suas 100 naves.");
        System.out.println("Seu objetivo: descobrir em qual nave a princesa está antes que seja tarde demais!");
        
        do {
            int marcianoPosicao = random.nextInt(100) + 1;
            int tentativa;
            int tentativasMaximas = 10;
            int tentativas = 0;
            boolean acertou = false;

            System.out.println("\nA missão começou! Você tem " + tentativasMaximas + " tentativas para encontrar a nave certa.");

            while (!acertou && tentativas < tentativasMaximas) {
                System.out.print("Digite o número da nave (1 a 100): ");
                while (!scanner.hasNextInt()) {
                    System.out.print("Sério? Isso nem parece um número! Tenta de novo, mas agora entre 1 e 100: ");
                    scanner.next(); 
                }
                tentativa = scanner.nextInt();
                
                if (tentativa < 1 || tentativa > 100) {
                    System.out.println("Número fora do intervalo! Digite um valor entre 1 e 100.");
                    continue;
                }

                tentativas++;
                
                if (tentativa == marcianoPosicao) {
                    System.out.println("Parabéns, Capitão! Você encontrou a Princesa Zayra em " + tentativas + " tentativas!");
                    acertou = true;
                    if (tentativas < melhorTentativa) {
                        melhorTentativa = tentativas;
                        System.out.println("\n\u2B50 NOVO RECORDE! Você fez o resgate mais rápido até agora! \u2B50");
                    }
                } else if (tentativa < marcianoPosicao) {
                    System.out.println("A nave correta está em um número maior!");
                } else {
                    System.out.println("A nave correta está em um número menor!");
                }

                if (tentativas == tentativasMaximas && !acertou) {
                    System.out.println("\nMissão falhou! Lorde Xarkon escapou e a Princesa Zayra estava na nave número " + marcianoPosicao + ".");
                }
            }
            
            System.out.print("\nDeseja tentar novamente? (s/n): ");
            jogarNovamente = scanner.next().equalsIgnoreCase("s");
        } while (jogarNovamente);

        System.out.println("\nObrigado por jogar! Seu melhor recorde foi " + (melhorTentativa == Integer.MAX_VALUE ? "-" : melhorTentativa) + " tentativas.");
        scanner.close();
    }
}
