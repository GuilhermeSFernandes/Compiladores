%{
#include <stdio.h>
#include <stdlib.h>
#include "nag.tab.h" // Arquivo de cabeçalho gerado pelo Bison

extern FILE *yyin;
void yyerror(const char *s);

// Funções para processamento dos tokens
char* processar_nome(char *nome) {
    // Implemente aqui sua lógica de processamento para o token NAME
    // Exemplo simples: apenas retornar o próprio nome
    return nome;
}

char* processar_evento(char *evento) {
    // Implemente aqui sua lógica de processamento para o token eventoGatilho
    // Exemplo simples: apenas retornar o próprio evento
    return evento;
}

char* processar_expressao(char *expressao) {
    // Implemente aqui sua lógica de processamento para a expressão lógica
    // Exemplo simples: apenas retornar a própria expressão
    return expressao;
}

%}

%union {
    char *str;
}

%token <str> NAME HASH CRENCAS OBJETIVOS PLANOS ABRE_CHAVE FECHA_CHAVE PONTO_VIRGULA ABRE_PARENTESE FECHA_PARENTESE E OU NAO

%type <str> Lcrencas Lobjetivos Lplanos nomeObjetivo lista_planos nomePlano tuplaPlano
%type <str> eventoGatilho contexto corpo expressaoLogica formulasCorpo

%%

programa: Lagentes { printf("{ \"mensagem\": \"Análise sintática concluída com sucesso!\" }\n"); exit(EXIT_SUCCESS); }
         ;

Lagentes: agente '%' { printf("{ \"mensagem\": \"Analisando agente...\" }\n"); }
         | Lagentes agente '%' { printf("{ \"mensagem\": \"Analisando próximo agente...\" }\n"); }
         ;

agente: HASH NAME CRENCAS Lcrencas OBJETIVOS Lobjetivos PLANOS Lplanos { 
    printf("{ \"agente\": \"%s\", \"crencas\": %s, \"objetivos\": %s, \"planos\": %s }\n", 
        processar_nome($2), $4, $6, $8); 
}
       ;

Lcrencas: ABRE_CHAVE lista_crencas FECHA_CHAVE { printf("{ \"mensagem\": \"Analisando lista de crenças...\" }\n"); }
        ;

lista_crencas: NAME PONTO_VIRGULA lista_crencas { printf("{ \"crenca\": \"%s\" }\n", $1); }
             | /* vazio */ { printf("[]\n"); }
             ;

Lobjetivos: ABRE_CHAVE lista_objetivos FECHA_CHAVE { printf("{ \"mensagem\": \"Analisando lista de objetivos...\" }\n"); }
         ;

lista_objetivos: nomeObjetivo PONTO_VIRGULA lista_objetivos { printf("{ \"objetivo\": \"%s\" }\n", $1); }
             | /* vazio */ { printf("[]\n"); }
             ;

nomeObjetivo: NAME { printf("\"%s\"", processar_nome($1)); }
          ;

Lplanos: ABRE_CHAVE lista_planos FECHA_CHAVE { printf("{ \"mensagem\": \"Analisando lista de planos...\" }\n"); }
         ;

lista_planos: nomePlano PONTO_VIRGULA lista_planos { printf("{ \"plano\": %s }\n", $1); }
             | /* vazio */ { printf("[]\n"); }
             ;

nomePlano: NAME tuplaPlano { printf("{ \"nome\": \"%s\", \"tupla\": %s }\n", processar_nome($1), $2); }
          ;

tuplaPlano: ABRE_PARENTESE eventoGatilho PONTO_VIRGULA contexto PONTO_VIRGULA corpo FECHA_PARENTESE
          { printf("{ \"eventoGatilho\": \"%s\", \"contexto\": \"%s\", \"corpo\": \"%s\" }\n", 
              processar_evento($2), processar_expressao($4), $6); }
          ;

eventoGatilho: NAME { printf("\"%s\"", processar_evento($1)); }
             ;

contexto: expressaoLogica { printf("\"%s\"", processar_expressao($1)); }
        | NAME { printf("\"%s\"", processar_nome($1)); }
        | /* vazio */ { printf("\"\""); }
        ;

expressaoLogica: NAME E NAME { printf("{ \"expressao\": \"%s %s %s\" }\n", 
                    processar_nome($1), "E", processar_nome($3)); }
               | NAME OU NAME { printf("{ \"expressao\": \"%s %s %s\" }\n", 
                    processar_nome($1), "OU", processar_nome($3)); }
               | NAO NAME { printf("{ \"expressao\": \"%s %s\" }\n", "NAO", processar_nome($2)); }
               ;

corpo: ABRE_CHAVE formulasCorpo FECHA_CHAVE { printf("{ \"corpo\": %s }\n", $2); }
     ;

formulasCorpo: NAME PONTO_VIRGULA formulasCorpo { printf("{ \"formula\": \"%s\" }\n", $1); }
                | /* vazio */ { printf("[]\n"); }
             ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
    exit(EXIT_FAILURE);
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
    printf("Iniciando análise sintática...\n");
    yyin = arquivo;
    yyparse();
    fclose(arquivo);
    return EXIT_SUCCESS;
}
