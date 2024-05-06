%{
#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;
extern int yylex();
void yyerror(const char *s);

%}
%union {
    char *str;
}

%token <str> NAME
%token HASH CRENCAS OBJETIVOS PLANOS ABRE_CHAVE FECHA_CHAVE PONTO_VIRGULA ABRE_PARENTESE FECHA_PARENTESE E OU NAO

%%

programa: Lagentes { printf("Análise sintática concluída com sucesso!\n"); exit(EXIT_SUCCESS); }
         ;

Lagentes: agente '%' { /* Ação de processamento */ }
         | Lagentes agente '%' { /* Ação de processamento */ }
         ;

agente: HASH NAME CRENCAS ':' Lcrencas OBJETIVOS ':' Lobjetivos PLANOS ':' Lplanos
         { /* Ação de processamento */ }
       ;

Lcrencas: ABRE_CHAVE lista_crencas FECHA_CHAVE { /* Ação de processamento */ }
        ;

lista_crencas: nomeCrenca PONTO_VIRGULA lista_crencas { /* Ação de processamento */ }
             | /* vazio */ { /* Ação de processamento */ }
             ;

nomeCrenca: NAME { /* Ação de processamento */ }
          ;

Lobjetivos: ABRE_CHAVE lista_objetivos FECHA_CHAVE { /* Ação de processamento */ }
         ;

lista_objetivos: nomeObjetivo PONTO_VIRGULA lista_objetivos { /* Ação de processamento */ }
             | /* vazio */ { /* Ação de processamento */ }
             ;

nomeObjetivo: NAME { /* Ação de processamento */ }
          ;

Lplanos: ABRE_CHAVE lista_planos FECHA_CHAVE { /* Ação de processamento */ }
         ;

lista_planos: nomePlano PONTO_VIRGULA lista_planos { /* Ação de processamento */ }
             | /* vazio */ { /* Ação de processamento */ }
             ;

nomePlano: NAME tuplaPlano { /* Ação de processamento */ }
          ;

tuplaPlano: ABRE_PARENTESE eventoGatilho PONTO_VIRGULA contexto PONTO_VIRGULA corpo FECHA_PARENTESE
          { /* Ação de processamento */ }
          ;

eventoGatilho: NAME { /* Ação de processamento */ }
             ;

contexto: expressaoLogica { /* Ação de processamento */ }
        | NAME { /* Ação de processamento */ }
        | /* vazio */ { /* Ação de processamento */ }
        ;

expressaoLogica: NAME E NAME { /* Ação de processamento */ }
               | NAME OU NAME { /* Ação de processamento */ }
               | NAO NAME { /* Ação de processamento */ }
               ;

corpo: ABRE_CHAVE formulasCorpo FECHA_CHAVE { /* Ação de processamento */ }
     ;

formulasCorpo: NAME { /* Ação de processamento */ }
             ;

%%

void yyerror(const char *s) {
    printf("Erro de sintaxe: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Uso: %s arquivo.nag\n", argv[0]);
        return EXIT_FAILURE;
    }
    FILE *arquivo = fopen(argv[1], "r");
    if (!arquivo) {
        perror("Erro ao abrir o arquivo");
        return EXIT_FAILURE;
    }
    yyin = arquivo;
    yyparse();
    fclose(arquivo);
    return EXIT_SUCCESS;
}